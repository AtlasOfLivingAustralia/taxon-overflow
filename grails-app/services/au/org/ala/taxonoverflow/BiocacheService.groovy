package au.org.ala.taxonoverflow

import org.codehaus.groovy.grails.web.json.JSONObject

class BiocacheService extends AbstractWebService {

    def grailsApplication

    def JSONObject getRecord(String id, boolean useApiKey = false) {
        def url = "${grailsApplication.config.biocache.baseUrl}/occurrence/${id.encodeAsURL()}"
        if (useApiKey) {
            url += "?apiKey=${grailsApplication.config.biocache.apiKey?:''}"
        }
        getJson(url)
    }

}
