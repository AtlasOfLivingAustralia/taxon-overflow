package au.org.ala.taxonoverflow

import grails.converters.JSON
import grails.converters.XML
import org.codehaus.groovy.grails.web.json.JSONObject

class WebServiceController {

    def userService
    def grailsApplication
    def questionService
    def elasticSearchService

    def index() {
        render([success: "true", version: grailsApplication.metadata['app.version']])
    }

    def createQuestionFromBiocache() {

        def results = [success:true]
        def body = request.JSON
        if (body) {
            def tags= body.tags as List<String>
            def occurrenceId = body.occurrenceId as String
            def user = userService.getUserFromUserId(body.userId)
            def questionType = (body.questionType as QuestionType) ?: QuestionType.Identification
            def serviceResult = questionService.createQuestionFromOccurrence(occurrenceId, questionType, tags, user)

            if (serviceResult) {
                results.success = true
                results.questionId = serviceResult.result?.id

                elasticSearchService.indexQuestion(serviceResult.result)

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
        if (setAnswerProperties(answer, answerDetails, messages)) {
            answer.save(failOnError: true, flush: true)
            results.success = true
        } else {
            results.message = messages.join(". ")
        }
        renderResults(results)
    }

    private static setAnswerProperties(Answer answer, Object answerDetails, List messages) {
        switch (answer.question.questionType) {
            case QuestionType.Identification:
                def scientificName = answerDetails.scientificName
                def identificationRemarks = answerDetails.identificationRemarks

                if (!scientificName) {
                    messages << "A scientific name must be supplied"
                } else {
                    answer.scientificName = scientificName
                    answer.description = identificationRemarks
                    return true
                }
                break
            default:
                messages << "Unhandled question type: ${answer.question.questionType?.toString()}"
        }

        return false
    }

    def submitAnswer() {

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
                if (setAnswerProperties(answer, answerDetails, messages)) {
                    answer.save(failOnError: true)
                    results.success = true
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

            def dir = params.int("dir") ?: 1 // positive is up, negative is down and 0 is retract existing vote

            if (answer && user) {
                def voteType = VoteType.Up
                if (dir < 0) {
                    voteType = VoteType.Down
                } else if (dir == 0) {
                    voteType = VoteType.Retract
                }
                questionService.castVoteOnAnswer(answer, user, voteType)
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

}
