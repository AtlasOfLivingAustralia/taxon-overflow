package au.org.ala.taxonoverflow

import grails.converters.JSON
import org.codehaus.groovy.grails.web.json.JSONElement
import org.springframework.web.client.RestClientException

class AbstractWebService {

    def JSONElement getJson(String url) {
        def conn = new URL(url).openConnection()
        try {
            conn.setConnectTimeout(10000)
            conn.setReadTimeout(50000)
            def json = conn.content.text
            return JSON.parse(json)
        } catch (Exception e) {
            def error = "Failed to get json from web service (${url}). ${e.getClass()} ${e.getMessage()}, ${e}"
            throw new RestClientException(error)
        }
    }

}

