package au.org.ala.taxonoverflow

import grails.converters.JSON
import grails.converters.XML
import org.codehaus.groovy.grails.web.json.JSONObject

class WebServiceController {

    def userService
    def grailsApplication
    def questionService

    def index() {
        render([success: "true", version: grailsApplication.metadata['app.version']])
    }

    def createQuestionFromBiocache() {
        def occurrenceId = params.occurrenceId
        def results = ['success':'true']

        Question question

        if (occurrenceId) {
            QuestionType questionType = (params.questionType as QuestionType) ?: QuestionType.Identification
            def user = userService.getUserFromUserId(params.userId)
            def tagParam = params.tags as String
            def tags = []
            if (tagParam?.trim()) {
                tags = tagParam.split(',')?.collect { String str -> str.trim() }
            }
            def messages = []
            question = questionService.createQuestionFromOccurrence(occurrenceId, questionType, tags, user, messages)
            if (!question) {
                results.message = messages.join(". ")
            }
        } else {
            def body = request.JSON
            if (body) {
                def tags= body.tags as List<String>
                occurrenceId = body.occurrenceId as String
                def user = userService.getUserFromUserId(body.userid)
                def questionType = (body.questionType as QuestionType) ?: QuestionType.Identification
                question = questionService.createQuestionFromOccurrence(occurrenceId, questionType, [], user)
            }
        }

        if (question) {
            results.questionId = question.id
        } else {
            results.success = false
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

    def submitAnswer(int id) {
        def question = Question.get(id);
        def results = [success: false]

        if (!params.userId) {
            results.message = "You must supply a userId!"
        } else if (!question) {
            results.message = "Invalid or missing question id!"
        } else {
            def user = userService.getUserFromUserId(params.userId)
            if (!user) {
                results.message = "Invalid user id!"
            } else {
                Answer answer
                switch (question.questionType) {
                    case QuestionType.Identification:

                        if (!params.scientificName) {
                            results.message = "A scientific name must be supplied"
                        } else {
                            answer = new Answer(question: question, scientificName: params.scientificName, description: params.identificationRemarks, user: user)
                            answer.save(failOnError: true)
                            results.success = true
                        }
                        break
                    default:
                        results.success = false
                        results.message = "Unhandled question type: ${question.questionType?.toString()}"
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

        if (user == answer.user) {
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

}
