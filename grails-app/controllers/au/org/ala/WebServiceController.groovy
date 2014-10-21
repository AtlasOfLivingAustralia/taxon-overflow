package au.org.ala

import au.org.ala.taxonoverflow.Subject
import grails.converters.JSON
import grails.converters.XML
import org.codehaus.groovy.grails.web.json.JSONObject

class WebServiceController {

    def biocacheService
    def grailsApplication
    def subjectService

    def index() {
        render([success: "true", version: grailsApplication.metadata['app.version']])
    }

    def createSubjectFromBiocache() {
        def occurrenceId = params.occurrenceId
        def results = ['success':'true']

        if (occurrenceId) {
            def occurrence = biocacheService.getRecord(occurrenceId)
            if (occurrence && (occurrence.raw?.uuid || occurrence.processed?.uuid)) {
                def errors = []
                if (validateOccurrenceRecord(occurrenceId, occurrence, errors)) {
                    def subject = new Subject(occurrenceId: occurrenceId)
                    subject.save()
                }
            }

            results.occurrence = occurrence
        } else {

            def body = request.JSON

            // TODO: make a subject from a JSON Post - post body may contain overriding information?

            if (body) {
            } else {
            }
        }

        renderResults(results)
    }

    private boolean validateOccurrenceRecord(String occurrenceId, JSONObject occurrence, List errors) {

        // first check if a subject already exists for this occurrence

        if (subjectService.subjectExists(occurrenceId)) {
            errors << "A subject already exists for this occurrence"
            return false
        }

        // TODO: Check that the occurrence record is sufficient to create a subject (i.e. contains the minimum set of required fields)


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
