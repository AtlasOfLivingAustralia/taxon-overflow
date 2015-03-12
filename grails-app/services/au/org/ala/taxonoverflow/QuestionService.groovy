package au.org.ala.taxonoverflow

import au.org.ala.taxonoverflow.notification.SendEmailNotification
import au.org.ala.web.CASRoles
import grails.transaction.NotTransactional
import grails.transaction.Transactional
import groovy.json.JsonSlurper
import org.apache.commons.lang.StringUtils
import org.codehaus.groovy.grails.web.json.JSONObject

@Transactional
class QuestionService {

    def ecodataService
    def biocacheService
    def authService
    def userService

    @NotTransactional
    def boolean questionExists(String occurrenceId) {
        def existing = Question.findByOccurrenceId(occurrenceId)
        return existing != null
    }

    def deleteQuestion(Question question) {
        if (question) {
            question.delete()
        }
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
    ServiceResult<Question> createQuestionFromEcodataService(String occurrenceId, QuestionType questionType, List<String> tags, User user, String comment) {

        def result = new ServiceResult<Question>(success: false)

        def occurrence = ecodataService.getRecord(occurrenceId)

        if(occurrence){
            def source = Source.findByName("ecodata")

            def question = Question.findByOccurrenceId(occurrenceId)

            if (!question) {

                question = new Question(user: user, occurrenceId: occurrenceId, questionType: questionType, source: source)
                question.save(failOnError: true)

                // Save the tags
                tags?.each {
                    if (!StringUtils.isEmpty(it)) {
                        def tag = new QuestionTag(question: question, tag: it)
                        tag.save()
                    }
                }

                if(comment){
                    addQuestionComment(question, user, comment)
                }

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
            result.fail("Unable to retrieve occurrence details for ${occurrenceId} from source ecodata")
        }

        return result
    }

    /**
     * To be refined to remove duplicate code
     */
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
                question.save(failOnError: true)

                // Save the tags
                tags?.each {
                    if (!StringUtils.isEmpty(it)) {
                        def tag = new QuestionTag(question: question, tag: it)
                        tag.save()
                    }
                }

                if(comment){
                    addQuestionComment(question, user, comment)
                }

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

    public boolean validateOccurrenceRecord(String occurrenceId, List errors) {
        // first check if a question already exists for this occurrence
        if (questionExists(occurrenceId)) {
            errors << "A question already exists for this occurrence"
            return false
        }
        return true
    }

    def deleteAnswer(Answer answer) {
        answer?.delete(flush: true)
    }

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

        return new ServiceResult<Answer>(result: answer, success: true)
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

    }

    def castVoteOnAnswer(Answer answer, User user, VoteType voteType) {

        if (!answer || !user) {
            return
        }

        def vote = AnswerVote.findByAnswerAndUser(answer, user)

        int newVoteValue = voteType == VoteType.Up ? 1 : -1

        if (vote?.voteValue == newVoteValue) {
            voteType = VoteType.Retract
        }


        if (voteType == VoteType.Retract) {
            if (vote) {
                vote.delete()
            }
        } else {
            if (!vote) {
                vote = new AnswerVote(user: user, answer: answer)
            }

            vote.voteValue = newVoteValue
            vote.save(failOnError: true)
        }
    }

    def canUserAcceptAnswer(Answer answer, User user) {
        // If the current user is one who asked the question, they can accept the answer
        if (answer.question.user == user) {
            return true
        }

        if (authService.userInRole(CASRoles.ROLE_ADMIN)) {
            return true
        }

        return false
    }

    def canUserEditQuestion(Question question, User user) {
        // If the current user is one who asked the question, they can edit the answer
        if (question.user == user) {
            return true
        }

        if (authService.userInRole(CASRoles.ROLE_ADMIN)) {
            return true
        }

        return false
    }

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
        def existing = QuestionTag.findByQuestionAndTag(question, tag)
        if (!existing) {
            def tagInstance = new QuestionTag(question: question, tag: tag)
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

}
