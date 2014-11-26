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
            def user = userService.getUserFromUserId(params.userid)
            question = questionService.createQuestionFromOccurrence(occurrenceId, questionType, [], user)
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
                switch (question.questionType) {
                    case QuestionType.Identification:

                        if (!params.scientificName) {
                            results.message = "A scientific name must be supplied"
                        } else {
                            def answer = new Answer(question: question, scientificName: params.scientificName, description: params.identificationRemarks, user: user)
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

}
