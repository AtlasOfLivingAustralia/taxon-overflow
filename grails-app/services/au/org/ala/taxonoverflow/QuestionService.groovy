package au.org.ala.taxonoverflow

import au.org.ala.taxonoverflow.notification.FollowQuestionByUser
import au.org.ala.taxonoverflow.notification.SendEmailNotification
import au.org.ala.web.CASRoles
import grails.converters.JSON
import grails.transaction.NotTransactional
import grails.transaction.Transactional
import groovy.json.JsonSlurper
import org.apache.commons.lang.StringUtils

@Transactional
class QuestionService {

    def grailsApplication

    def ecodataService
    def biocacheService
    def authService
    def userService
    ElasticSearchService elasticSearchService

    @NotTransactional
    def boolean questionExists(String occurrenceId) {
        def existing = Question.findByOccurrenceId(occurrenceId)
        return existing != null
    }

    def bulkLoadFromEcodata(){
        def questionsLoaded = 0
        def source = Source.findByName("ecodata")
        def url = source.wsBaseUrl + "uncertainIdentifications"
        def listOfIds = AbstractWebService.getJson(url)

        listOfIds.each { occurrenceId ->
            def occurrence = ecodataService.getRecord(occurrenceId)
            //only add records with images
            if(occurrence && occurrence.imageIds) {
                def question = Question.findByOccurrenceId(occurrenceId)
                if (!question) {
                    def user = userService.getUserFromUserId(occurrence.userId)
                    question = new Question(user: user, occurrenceId: occurrenceId, questionType: QuestionType.IDENTIFICATION, source: source)
                    question.save(failOnError: true)
                    questionsLoaded++
                }
            }
        }
        questionsLoaded
    }


    /**
     * To be refined to remove duplicate code
     */
    @FollowQuestionByUser
    ServiceResult<Question> createQuestionFromEcodataService(String occurrenceId, QuestionType questionType, List<String> tags, User user, String comment) {

        def result = new ServiceResult<Question>(success: false)

        def occurrence = ecodataService.getRecord(occurrenceId)

        if(occurrence){
            def source = Source.findByName("ecodata")

            def question = Question.findByOccurrenceId(occurrenceId)

            if (!question) {

                question = new Question(user: user, occurrenceId: occurrenceId, questionType: questionType, source: source)

                // Save the tags
                tags?.each {
                    if (!StringUtils.isEmpty(it)) {
                        def tag = new QuestionTag(question: question, tag: it.trim())
                        question.addToTags(tag)
                    }
                }

                if(comment){
                    question.addToComments(new QuestionComment(question: question, user: user, comment: comment))
                }

                question.save(failOnError: true)

                checkIfUserProvidesPossibleAnswer(question, occurrence, user)

                result.success(Question.load(question.id))
            } else {
                def messages = ["Question already exists"]
                if(comment){
                    addQuestionComment(question, user, comment)
                    messages  << "User comment added to question"
                }
                result.success(question, messages)
            }

        } else {
            result.fail("Unable to retrieve occurrence details for ${occurrenceId} from source ecodata")
        }

        return result
    }

    /**
     *
     * @param question
     * @param occurrence
     * @param user
     */
    public void checkIfUserProvidesPossibleAnswer(Question question, LinkedHashMap<String, Serializable> occurrence, User user) {
        if (question.questionType == QuestionType.IDENTIFICATION && occurrence['scientificName']) {
            Answer answer = new Answer(question: question, user: user)
            def answerDetails = [
                    scientificName   : occurrence['scientificName'],
                    commonName       : occurrence['commonName'],
                    occurrenceRemarks: occurrence['occurrenceRemarks']
            ]
            if (QuestionService.setAnswerProperties(answer, answerDetails, [])) {
                answer.save()
            }
        }
    }

    /**
     * To be refined to remove duplicate code
     */
    @FollowQuestionByUser
    ServiceResult<Question> createQuestionFromOccurrence(String occurrenceId, QuestionType questionType, List<String> tags, User user, String comment) {

        def result = new ServiceResult<Question>(success: false)

        def occurrence = biocacheService.getRecord(occurrenceId)

        if (occurrence) {

            def question = Question.findByOccurrenceId(occurrenceId)
            // the id used to search for an occurrence may not be canonical, so
            // once we've found an occurrence, use the canonical id from then on...
            if (!question) {
                def source = Source.findByName("biocache")
                question = new Question(user: user, occurrenceId: occurrenceId, questionType: questionType, source: source)

                // Save the tags
                tags?.each {
                    if (!StringUtils.isEmpty(it)) {
                        def tag = new QuestionTag(question: question, tag: it.trim())
                        question.addToTags(tag)
                    }
                }

                if(comment){
                    question.addToComments(new QuestionComment(question: question, user: user, comment: comment))
                }

                question.save(failOnError: true)

                checkIfUserProvidesPossibleAnswer(question, occurrence, user)

                result.success(question)
            } else {
                def messages = ["Question already exists"]
                if(comment){
                    addQuestionComment(question, user, comment)
                    messages  << "User comment added to question"
                }
                result.success(question, messages)
            }

        } else {
            result.fail("Unable to retrieve occurrence details for ${occurrenceId} from source biocache")
        }

        return result
    }

    def deleteAnswer(Answer answer) {
        answer?.delete(flush: true)
    }

    @FollowQuestionByUser
    @SendEmailNotification
    ServiceResult setAnswer(Answer answer, LinkedHashMap<String, Boolean> results) {
        answer.save(failOnError: true)
        results.success = true

        return new ServiceResult<Answer>(result: answer, success: true)
    }

    ServiceResult updateAnswer(Answer answer, LinkedHashMap<String, Boolean> results) {
        answer.save(failOnError: true, flush: true)
        results.success = true

        return new ServiceResult<Answer>(result: answer, success: true)
    }

    @SendEmailNotification
    ServiceResult acceptAnswer(Answer answer) {

        if (!answer) {
            return
        }

        // first check if there any other accepted answers for this question, and if there are, reset them (only one accepted answer at this point)
        def existing = Answer.findAllByQuestionAndAccepted(answer.question, true)
        existing.each { acceptedAnswer ->
            acceptedAnswer.accepted = false
            acceptedAnswer.dateAccepted = new Date()
            acceptedAnswer.save(failOnError: true)
        }

        answer.accepted = true
        answer.save()

        //TODO redo this with annotations
        updateRecordAtSource(answer.questionId)

        return new ServiceResult<Answer>(result: answer, success: true)
    }

    static setAnswerProperties(Answer answer, Object answerDetails, List messages) {

        //retrieve a description, and then any additional properties
        //are lumped into DwC
        answer.description = answerDetails.description

        def validRequest = true
        def darwinCore = [:]

        //required fields
        answer.question.questionType.getRequiredFields().each {
            if (!answerDetails[it]) {
                messages << "A ${it} must be supplied"
                validRequest = false
            } else {
                darwinCore[it] = answerDetails[it]
            }
        }
        //optional fields
        answer.question.questionType.getOptionalFields().each {
            darwinCore[it] = answerDetails[it]
        }

        answer.darwinCore = (darwinCore as JSON).toString()

        return validRequest
    }

    def unacceptAnswer(Answer answer) {

        if (!answer) {
            return
        }

        if (answer.accepted) {
            answer.accepted = false
            answer.dateAccepted = null
            answer.save(failOnError: true)
        }

        //TODO redo this with annotations
        updateRecordAtSource(answer.questionId)
    }

    /**
     * Cast the vote, changing the accepted answer if required.
     *
     * @param answer
     * @param user
     * @param voteType
     * @return
     */
    def castVoteOnAnswer(Answer answer, User user, VoteType voteType) {

        if (!answer || !user) {
            return false
        }

        def currentAcceptedAnswer = answer.question.answers.find { it.accepted }


        def vote = AnswerVote.findByAnswerAndUser(answer, user)

        int newVoteValue = voteType == VoteType.Up ? 1 : -1

        if (vote?.voteValue == newVoteValue) {
            voteType = VoteType.Retract
        }

        if (voteType == VoteType.Retract) {
            if (vote) {
                answer.votes.remove(vote)
                vote.delete(failOnError: true)
            }
        } else {
            if (!vote) {
                vote = new AnswerVote(user: user, answer: answer)
            }

            vote.voteValue = newVoteValue
            vote.save(failOnError: true)
        }

        //generate a map of [answer: vote count]
        def answerRanking = [:]
        answer.question.answers.each {
            def score = it.votes.sum { v -> v.voteValue } ?: 0
            answerRanking[it] = score
        }

        //order by score, and retrieve top answer
        def topAnswer = answerRanking.sort { it.value * -1 }.take(1).keySet().first()


        def newAcceptedAnswer = null

        //update the answers
        answer.question.answers.each {
            if(it == topAnswer && answerRanking[topAnswer] >= grailsApplication.config.accepted.answer.threshold){
                //are there any other answers with a greater number of votes
                newAcceptedAnswer = it
                it.accepted = true
            } else {
                it.accepted = false
            }
            it.save(failOnError: true)
        }

        //return true if there a change in the accepted answer
        currentAcceptedAnswer != newAcceptedAnswer
    }

    /**
     * Updates the source system with the latest answer.
     *
     * TODO we should be able to generalise this and remove hardcode 'ecodata' references
     * @param question
     */
    def updateRecordAtSource(questionId){

        def question = Question.get(questionId)

        def acceptedAnswer = question.answers.find { it.accepted }
        if(acceptedAnswer){
            //lets to a HTTP POST
            if(question.source.name == 'ecodata'){
                def identifiedBy = authService.getUserForUserId(acceptedAnswer.getUser().alaUserId)
                ecodataService.updateRecord(question.id, question.occurrenceId, acceptedAnswer.darwinCore, identifiedBy, acceptedAnswer.dateCreated)
            } else {
                log.warn("Updates not supported for source system: " + question.source.name)
            }
        } else {
            //should we revert to highest ranked or the original identification.
            log.warn("Accepted answer not available, we need to revert to original identification - not implemented ! ")
        }
    }

    def canUserAcceptAnswer(Answer answer, User user) {
        // If the current user is one who asked the question, they can accept the answer
        if (user == answer.question.user) {
            return true
        }

        if (authService.userInRole(CASRoles.ROLE_ADMIN) || authService.userInRole(grailsApplication.config.expertRole)) {
            return true
        }

        return false
    }

    def canUserEditQuestion(Question question, User user) {
        // If the current user is one who asked the question, they can edit the answer
        if (question.user == user) {
            return true
        }

        if (authService.userInRole(CASRoles.ROLE_ADMIN) || authService.userInRole(grailsApplication.config.expertRole)) {
            return true
        }

        return false
    }

    @FollowQuestionByUser
    @SendEmailNotification
    ServiceResult<QuestionComment> addQuestionComment(Question question, User user, String commentText) {
        if (!question) {
            return new ServiceResult<QuestionComment>().fail("No question supplied")
        }
        if (!user) {
            return new ServiceResult<QuestionComment>().fail("No user supplied")
        }

        if (!commentText) {
            return new ServiceResult<QuestionComment>().fail("No comment text supplied")
        }

        //does this comment already exist ?
        def comment = QuestionComment.findByQuestionAndUserAndComment(question, user, commentText)
        if(!comment){
            comment = new QuestionComment(question: question, user: user, comment: commentText)
            comment.save(failOnError: true)
        }
        return new ServiceResult<QuestionComment>(result: comment, success: true)
    }

    @FollowQuestionByUser
    @SendEmailNotification
    ServiceResult<AnswerComment> addAnswerComment(Answer answer, User user, String commentText) {
        if (!answer) {
            return new ServiceResult<AnswerComment>().fail("No answer supplied")
        }
        if (!user) {
            return new ServiceResult<AnswerComment>().fail("No user supplied")
        }

        if (!commentText) {
            return new ServiceResult<AnswerComment>().fail("No comment text supplied")
        }

        def comment = new AnswerComment(answer: answer, user: user, comment: commentText)
        comment.save(failOnError: true)
        return new ServiceResult<AnswerComment>(result: comment, success: true)
    }

    ServiceResult<AnswerComment> removeAnswerComment(AnswerComment comment, User user) {
        if (!comment) {
            return new ServiceResult<AnswerComment>().fail("No comment supplied")
        }
        if (!user) {
            return new ServiceResult<AnswerComment>().fail("No user supplied")
        }

        // TODO: check permissions?

        comment.delete(flush: true)
        return new ServiceResult<AnswerComment>(result: comment, success: true)
    }

    ServiceResult<QuestionComment> removeQuestionComment(QuestionComment comment, User user) {
        if (!comment) {
            return new ServiceResult<QuestionComment>().fail("No comment supplied")
        }
        if (!user) {
            return new ServiceResult<QuestionComment>().fail("No user supplied")
        }

        // TODO: check permissions?

        comment.delete(flush: true)
        return new ServiceResult<QuestionComment>(result: comment, success: true)
    }

    @SendEmailNotification
    ServiceResult<QuestionTag> addQuestionTag(Question question, String tag) {
        if (!question) {
            return new ServiceResult<QuestionTag>().fail("No question supplied")
        }
        if (!tag) {
            return new ServiceResult<QuestionTag>().fail("No tag supplied")
        }

        // Find existing tag...
        def existing = QuestionTag.findByQuestionAndTagIlike(question, tag.toLowerCase())
        if (!existing) {
            def tagInstance = new QuestionTag(question: question, tag: tag.toLowerCase())
            tagInstance.save()
            return new ServiceResult<QuestionTag>(result: tagInstance, success: true)
        } else {
            return new ServiceResult<QuestionTag>(result: existing, success: true)
        }
    }

    def ServiceResult<QuestionTag> removeQuestionTag(Question question, String tag) {
        if (!question) {
            return new ServiceResult<QuestionTag>().fail("No question supplied")
        }
        if (!tag) {
            return new ServiceResult<QuestionTag>().fail("No tag supplied")
        }

        // Find existing tag...
        def existing = QuestionTag.findByQuestionAndTag(question, tag)
        if (!existing) {
            return new ServiceResult<QuestionTag>().fail("Question does not have tag ${tag}")
        } else {
            existing.delete(flush: true)
            return new ServiceResult<QuestionTag>(result: existing, success: true)
        }
    }

    ServiceResult<User> followOrUnfollowQuestionByUser(boolean follow, Long questionId, Long alaUserId) {
        Question question = Question.get(questionId)
        if (!question) {
            return new ServiceResult<User>().fail("Question provided with id: ${questionId} is invalid")
        }

        User user =  User.findByAlaUserId(alaUserId)
        if (!user) {
            return new ServiceResult<User>().fail("User provided with id: ${alaUserId} is invalid")
        }

        if (follow) {
            user.followedQuestions.add(question)
            user.save(flush: true)
            return new ServiceResult<User>(success: true, messages: ["User with id: ${alaUserId} is now following question with id: ${questionId}"])
        } else {
            user.followedQuestions.remove(question)
            user.save(flush: true)
            return new ServiceResult<User>(success: true, messages: ["User with id: ${alaUserId} is now not following question with id: ${questionId}"])
        }
    }

    Boolean followingQuestionStatus(Long questionId, Long alaUserId) {
        Question question = Question.get(questionId)
        User user =  User.findByAlaUserId(alaUserId)

        return user.followedQuestions.contains(question)
    }

    ServiceResult<List<Question>> searchByTagsAndDatedCriteria(Map searchParams) {
        List<String> questionIdList = elasticSearchService.searchByTagsAndDatedCriteria(searchParams)
        return new ServiceResult<List<Question>>(result: Question.findAllByIdInList(questionIdList) ?: [], success: true)
    }

    ServiceResult<Question> deleteQuestion(long questionId) {
        Question question = Question.get(questionId);
        ServiceResult<Question> serviceResult = new ServiceResult<>()
        if (question) {
            // We remove the followedQuestions references to this question first
            question.followers?.each {user ->
                user.followedQuestions.remove(question)
                user.save(flush: true)
            }
            question.followers?.clear()
            // Now we can remove the question from the DB and the Elasticsearch index
            question.delete(flush: true)
            elasticSearchService.deleteQuestionFromIndex(question)
            serviceResult.success(question, ["The question with id \"${questionId}\" has been scheduled for removal."])
        } else {
            serviceResult.fail("The provided question id \"${questionId}\" is not valid")
        }

        return serviceResult
    }


    /**
     * This should be a formal domain or command object constraint but the way web services and services are implemented make this impossible for the time being
     * @return Boolean
     */
    @NotTransactional
    boolean isAnswerRepeated(Answer answer) {
        Set answers = answer.question.answers
        boolean isAnswerRepeated = false;
        if (answers.size() > 0 && answer.question.questionType == QuestionType.IDENTIFICATION) {
            String scientificName = new JsonSlurper().parseText(answer.darwinCore)?.scientificName
            isAnswerRepeated = answers.find {new JsonSlurper().parseText(it.darwinCore)?.scientificName == scientificName} != null
        }

        return isAnswerRepeated
    }
}
