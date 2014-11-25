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


}
