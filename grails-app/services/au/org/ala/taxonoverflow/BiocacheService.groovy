package au.org.ala.taxonoverflow

import org.codehaus.groovy.grails.web.json.JSONObject

class BiocacheService extends AbstractWebService {

    def grailsApplication

    def JSONObject getRecord(String id, boolean useApiKey = false) {
        def ct = new CodeTimer("Getting occurrence from biocache")
        try {
            def url = "${grailsApplication.config.biocache.baseUrl}/occurrence/${id.encodeAsURL()}"
            if (useApiKey) {
                url += "?apiKey=${grailsApplication.config.biocache.apiKey ?: ''}"
            }
            getJson(url)
        } finally {
            ct.stop(true)
        }
    }

    def JSONObject getRecords(List<String> ids, boolean useApiKey = false) {
        def ct = new CodeTimer("Getting ${ids.size()} occurrences from biocache")
        try {
            def queryString = URLEncoder.encode("id:(" + ids.join(" OR ") + ")", "utf-8")
            def url = "${grailsApplication.config.biocache.baseUrl}/occurrences/search?q=${queryString}"
            if (useApiKey) {
                url += "?apiKey=${grailsApplication.config.biocache.apiKey ?: ''}"
            }
            def json = getJson(url)

            if (json.occurrences) {
                return json.occurrences.collectEntries {
                    [ (it.uuid) : it ]
                }
            }

            return [:]

        } finally {
            ct.stop(true)
        }
    }

}
