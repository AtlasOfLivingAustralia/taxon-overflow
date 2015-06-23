package au.org.ala.taxonoverflow

import grails.async.Promise
import grails.converters.JSON
import grails.converters.XML
import static grails.async.Promises.*

class WebServiceController {

    def userService
    def grailsApplication
    def questionService
    def authService


    def index() {
        def model = [success: "true", version: grailsApplication.metadata['app.version']]
        renderResults(model)
    }

    def listQuestionTypes(){
        renderResults(QuestionType.values().collect { it.name() })
    }

    def questionIdLookup(){
        //FIXME move to service and make more efficient
        def occurrenceIDs = request.JSON
        def list = []
        occurrenceIDs.each {
            def question = Question.findByOccurrenceId(it)
            if(question){
                list << question.id
            } else {
                list << ""
            }
        }
        renderResults(list)
    }

    /**
     * A utility to bulk load questions.
     *
     * @return
     */
    def bulkLoadFromEcodata(){
        def loadedCount = questionService.bulkLoadFromEcodata()
        def model = [success:true, loadedCount: loadedCount]
        renderResults(model)
    }

    /**
     * Create a question from an external source.
     *
     * @return
     */
    def createQuestionFromExternal(){
        def body = request.JSON
        if(body.source && body.source == 'ecodata'){
          createQuestionFromEcodata()
        } else if(body.source && body.source == 'biocache'){
          createQuestionFromBiocache()
        } else {
          //send error
          def result = new ServiceResult<Question>(success: false)
          if(body.source){
              result.messages = ["Unrecognised 'source' value"]
          } else {
              result.messages = ["Source unspecified"]
          }
          renderResults(result)
        }
    }

    def createQuestionFromEcodata(){

        def results = [success:false]
        def body = request.JSON
        if (body) {
            def tags = body.tags instanceof String ? body.tags.split(",").collect{it.trim()} : body.tags as List<String>
            def comment = body.comment
            def user = userService.getUserFromUserId(body.userId)
            def occurrenceId = body.occurrenceId as String
            def questionType = (body.questionType as QuestionType) ?: QuestionType.IDENTIFICATION
            def serviceResult = questionService.createQuestionFromEcodataService(occurrenceId, questionType, tags, user, comment)

            if (serviceResult) {
                results.success = true
                results.questionId = serviceResult.result?.id
            } else {
                results.success = false
                results.message = serviceResult.combinedMessages
            }
        }
        renderResults(results)
    }

    def createQuestionFromBiocache() {

        def results = [success:true]
        def body = request.JSON
        if (body) {
            def tags = body.tags instanceof String ? body.tags.split(",").collect{it.trim()} : body.tags as List<String>
            def occurrenceId = body.occurrenceId as String
            def user = userService.getUserFromUserId(body.userId)
            def comment = body.comment
            def questionType = (body.questionType as QuestionType) ?: QuestionType.IDENTIFICATION
            def serviceResult = questionService.createQuestionFromOccurrence(occurrenceId, questionType, tags, user, comment)

            if (serviceResult) {
                results.success = true
                results.questionId = serviceResult.result?.id
            } else {
                results.success = false
                results.message = serviceResult.combinedMessages
            }

        }

        renderResults(results)
    }

    private renderResults(Object results, int responseCode = 200) {

        withFormat {
            json {
                def jsonStr = results as JSON
                if (params.callback) {
                    render("${params.callback}(${jsonStr})")
                } else {
                    render(jsonStr)
                }
            }
            xml {
                render(results as XML)
            }
        }
        response.addHeader("Access-Control-Allow-Origin", "")
        response.status = responseCode
    }

    def updateAnswer() {
        def answerDetails = request.JSON
        def results = [success: false]

        if (!answerDetails) {
            results.message = "You must supply a JSON body"
            renderResults(results)
            return
        }

        def answer = Answer.get(params.int("id")) ?: Answer.get(answerDetails.answerId as Long)

        if (!answer) {
            results.message = "You must supply a JSON body"
            renderResults(results)
            return
        }

        def messages = []
        if (QuestionService.setAnswerProperties(answer, answerDetails, messages)) {
            questionService.updateAnswer(answer, results)
        } else {
            results.message = messages.join(". ")
        }
        renderResults(results)
    }

    def submitAnswer() {
        // TODO This is not the way to perform validation
        def answerDetails = request.JSON
        def results = [success: false]

        if (!answerDetails) {
            results.message = "You must supply a JSON body"
            renderResults(results)
            return
        }

        def question = Question.get(answerDetails.questionId ?: 0) ?:  Question.get(params.int('id'));

        if (!question) {
            results.message = "You must supply a questionId (either on URL or in JSON body)"
            renderResults(results)
            return
        }


        if (!answerDetails.userId) {
            results.message = "You must supply a userId!"
        } else if (!question) {
            results.message = "Invalid or missing question id!"
        } else {
            def user = userService.getUserFromUserId(answerDetails.userId)
            if (!user) {
                results.message = "Invalid user id!"
            } else {
                Answer answer = new Answer(question: question, user: user)

                def messages = []
                if (QuestionService.setAnswerProperties(answer, answerDetails, messages)) {
                    if (questionService.isAnswerRepeated(answer)) {
                        results.message = "Someone has already post this answer"
                    } else {
                        questionService.setAnswer(answer, results)
                    }
                } else {
                    results.success = false
                    results.message = messages.join(". ")
                }
            }
        }
        renderResults(results)
    }

    def deleteAnswer(long id) {
        def answer = Answer.get(id)
        def results = [success: false]
        if (answer) {
            questionService.deleteAnswer(answer)
            results.success = true
        } else {
            results.message = "Invalid or missing answer id!"
        }
        renderResults(results)
    }

    def acceptAnswer(long id) {
        def answer = Answer.get(id)
        def results = [success: false]
        if (answer) {
            questionService.acceptAnswer(answer)
            results.success = true
        } else {
            results.message = "Invalid or missing answer id!"
        }
        renderResults(results)
    }

    def unacceptAnswer(long id) {
        def answer = Answer.get(id)
        def results = [success: false]
        if (answer) {
            questionService.unacceptAnswer(answer)
            results.success = true
        } else {
            results.message = "Invalid or missing answer id!"
        }
        renderResults(results)
    }

    def castVoteOnAnswer(long id) {

        def results = [success: false]

        def answer = Answer.get(id)
        def user = userService.getUserFromUserId(params.userId)

        if (user == answer.user && false) {
            // cannot vote on own answer!
            results.message = "You cannot vote on your own answer!"
        } else {

            int dir = params.int("dir")

            if (answer && user) {
                def voteType = VoteType.Up
                if (dir < 0) {
                    voteType = VoteType.Down
                } else if (dir == 0) {
                    voteType = VoteType.Retract
                }
                def acceptedAnswerChange = questionService.castVoteOnAnswer(answer, user, voteType)
                if(acceptedAnswerChange) {
                    log.debug("Accepted answer for question #${answer.question.id} has changed to #${answer.id} = ${answer.darwinCore}")
                    Promise p = task {
                        // Long running task
                        questionService.updateRecordAtSource(answer.question.id)
                    }
                } else {
                    log.debug("No change in accepted answer for question #${answer.question.id}")
                }
                results.success = true
            } else {
                results.message = "Invalid or missing answer id!"
            }
        }

        renderResults(results)
    }

    def addQuestionComment() {
        def results = [success: false]
        def commentData = request.JSON

        def user = User.findByAlaUserId(commentData?.userId)
        if (!user) {
            results.message = "Invalid or missing userId"
            renderResults(results)
            return
        }

        def question = Question.get(params.int("id")) ?: Question.get(commentData?.questionId)
        if (!question) {
            results.message = "Invalid or missing questionId"
            renderResults(results)
            return
        }

        def comment = commentData.comment
        if (!comment) {
            results.message = "Must supply a comment!"
            renderResults(results)
            return
        }

        def serviceResults = questionService.addQuestionComment(question, user, comment)
        if (serviceResults) {
            results.success = true
            results.commentId = serviceResults.get().id
        } else {
            results.message = serviceResults.getCombinedMessages()
        }
        renderResults(results)
    }

    def addAnswerComment() {
        def results = [success: false]
        def commentData = request.JSON

        def user = User.findByAlaUserId(commentData?.userId)
        if (!user) {
            results.message = "Invalid or missing userId"
            renderResults(results)
            return
        }

        def answer = Answer.get(params.int("id")) ?: Answer.get(commentData?.answerId)
        if (!answer) {
            results.message = "Invalid or missing answerId"
            renderResults(results)
            return
        }

        def comment = commentData.comment
        if (!comment) {
            results.message = "Must supply a comment!"
            renderResults(results)
            return
        }

        def serviceResults = questionService.addAnswerComment(answer, user, comment)
        if (serviceResults) {
            results.success = true
            results.commentId = serviceResults.get().id
        } else {
            results.message = serviceResults.getCombinedMessages()
        }
        renderResults(results)
    }

    def deleteAnswerComment() {
        def results = [success: false]
        def commentData = request.JSON

        def user = User.findByAlaUserId(commentData?.userId)
        if (!user) {
            results.message = "Invalid or missing userId"
            renderResults(results)
            return
        }

        def comment = AnswerComment.get(params.int("id")) ?: AnswerComment.get(commentData?.commentId)
        if (!comment) {
            results.message = "Invalid or missing commentId"
            renderResults(results)
            return
        }

        def serviceResults = questionService.removeAnswerComment(comment, user)
        if (serviceResults) {
            results.success = true
            results.commentId = serviceResults.get().id
        } else {
            results.message = serviceResults.getCombinedMessages()
        }
        renderResults(results)
    }

    def deleteQuestionComment() {
        def results = [success: false]
        def commentData = request.JSON

        def user = User.findByAlaUserId(commentData?.userId)
        if (!user) {
            results.message = "Invalid or missing userId"
            renderResults(results)
            return
        }

        def comment = QuestionComment.get(params.int("id")) ?: QuestionComment.get(commentData?.commentId)
        if (!comment) {
            results.message = "Invalid or missing commentId"
            renderResults(results)
            return
        }

        def serviceResults = questionService.removeQuestionComment(comment, user)
        if (serviceResults) {
            results.success = true
            results.commentId = serviceResults.get().id
        } else {
            results.message = serviceResults.getCombinedMessages()
        }
        renderResults(results)
    }

    def addTagsToQuestion() {

        def results = [success: false]
        def requestData = request.JSON

        def question = Question.get(params.int("id")) ?: Question.get(requestData?.questionId)
        if (!question) {
            results.message = "Invalid or missing questionId"
            renderResults(results)
            return
        }

        def tags = requestData?.tags as String
        tags = tags ?: params.tags

        List<String> listTags = tags.split(',')

        def serviceResults = questionService.addQuestionTags(question, listTags)
        if (serviceResults) {
            results.success = true
        } else {
            results.message = serviceResults.getCombinedMessages()
        }
        renderResults(results)
    }

    def removeTagFromQuestion() {

        def results = [success: false]
        def requestData = request.JSON

        def question = Question.get(params.int("id")) ?: Question.get(requestData?.questionId)
        if (!question) {
            results.message = "Invalid or missing questionId"
            renderResults(results)
            return
        }

        def tag = requestData?.tag as String
        tag = tag ?: params.tag

        def serviceResults = questionService.removeQuestionTag(question, tag)
        if (serviceResults) {
            results.success = true
            results.tagId = serviceResults.get().id
        } else {
            results.message = serviceResults.getCombinedMessages()
        }
        renderResults(results)
    }

    def editQuestionTitle() {
        def requestData = request.JSON
        Question question = Question.get(requestData?.questionId)
        ServiceResult<Question> serviceResult = new ServiceResult<Question>()
        if (question) {
            question.title = requestData?.title.trim()
            serviceResult.success(question.save())
        } else {
            serviceResult.fail("The provided question id '$questionId' is not valid")
        }

        renderResults(serviceResult)
    }

    def follow(Long questionId, Long userId) {
        render questionService.followOrUnfollowQuestionByUser(true, questionId, userId) as JSON
    }

    def unfollow(Long questionId, Long userId) {
        render questionService.followOrUnfollowQuestionByUser(false, questionId, userId) as JSON
    }

    def followingQuestionStatus(Long questionId, Long userId) {
        render([following : questionService.followingQuestionStatus(questionId, userId)] as JSON)
    }

    def followTag(String tag, String userId) {
        if (!userId) {
            def user = userService.getCurrentUser()
            userId = user.alaUserId
        }
        render userService.followOrUnfollowTagByUser(true, tag, userId) as JSON
    }

    def unfollowTag(String tag, String userId) {
        if (!userId) {
            def user = userService.getCurrentUser()
            userId = user.alaUserId
        }
        render userService.followOrUnfollowTagByUser(false, tag, userId) as JSON
    }

    def getFollowedTagsForUserId(String userId) {
        if (!userId) {
            def user = userService.getCurrentUser()
            userId = user.alaUserId
        }
        render userService.getFollowedTagsForUserId(userId) as JSON
    }

    def switchUserNotifications() {
        String alaUserId = authService.userId
        if (!alaUserId) {
            render(new ServiceResult<User>().fail("No valid ala user id provided") as JSON)
        }
        render(userService.switchUserNotifications(alaUserId, params.enable) as JSON)

    }

    static final enum QuestionSearchDatedCriteria {
        dateCreated(['dateCreated']),
        comments(['comments.dateCreated', 'answers.comments.dateCreated']),
        identifications(['answers.dateCreated']),
        activity(['comments.dateCreated', 'answers.dateCreated', 'answers.comments.dateCreated'])

        List<String> searchFields

        QuestionSearchDatedCriteria( List<String> searchFields) {
            this.searchFields = searchFields
        }
    }

    def questionSearch() {

        Map searchParams = [tags: params.tags]
        QuestionSearchDatedCriteria criteria = QuestionSearchDatedCriteria.find { criteria ->
            params[criteria.toString()] != null
        }
        if (criteria) {
            searchParams << ["criteria": criteria, "date": params[criteria.toString()]]
        }

        ServiceResult<Question> serviceResult = validateQuestionSearchParams(searchParams)
        if(!serviceResult.success) {
            render serviceResult as JSON
        } else {
            render questionService.searchByTagsAndDatedCriteria(searchParams) as JSON
        }
    }

    private ServiceResult<Question> validateQuestionSearchParams(LinkedHashMap<String, Object> searchParams) {
        ServiceResult<Question> serviceResult = new ServiceResult<>(
                success: true,
                result: [])

        if (!searchParams.tags) {
            serviceResult.fail("No parameter \"tags\" provided.")
        }

        if (!searchParams.criteria) {
            serviceResult.fail("No valid date criteria provided")
        }

        if (searchParams.date) {
            try {
                Date.parse('yyyy-MM-dd', searchParams.date)
            } catch (e) {
                serviceResult.fail("The date provided ${searchParams.date} is not a valid date with format \"yyyy=MM-dd\"")
            }
        } else {
            serviceResult.fail("No valid date provided")
        }

        return serviceResult
    }
}
