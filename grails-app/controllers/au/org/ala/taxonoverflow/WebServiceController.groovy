package au.org.ala.taxonoverflow

import grails.converters.JSON
import grails.converters.XML
import org.codehaus.groovy.grails.web.json.JSONObject

class WebServiceController {

    def biocacheService
    def grailsApplication
    def questionService

    def index() {
        render([success: "true", version: grailsApplication.metadata['app.version']])
    }

    def createQuestionFromBiocache() {
        def occurrenceId = params.occurrenceId
        def results = ['success':'true']

        if (occurrenceId) {
            QuestionType questionType = (params.questionType as QuestionType) ?: QuestionType.Identification
            def occurrence = biocacheService.getRecord(occurrenceId)
            if (occurrence && (occurrence.raw?.uuid || occurrence.processed?.uuid)) {
                def errors = []
                if (validateOccurrenceRecord(occurrenceId, occurrence, errors)) {
                    def question = new Question(occurrenceId: occurrenceId, questionType: questionType)
                    question.save()
                }
            }

            results.occurrence = occurrence
        } else {

            def body = request.JSON

            // TODO: make a question from a JSON Post - post body may contain overriding information?

            if (body) {
            } else {
            }
        }

        renderResults(results)
    }

    private boolean validateOccurrenceRecord(String occurrenceId, JSONObject occurrence, List errors) {

        // first check if a question already exists for this occurrence

        if (questionService.questionExists(occurrenceId)) {
            errors << "A question already exists for this occurrence"
            return false
        }

        // TODO: Check that the occurrence record is sufficient to create a question (i.e. contains the minimum set of required fields)


        return true
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
