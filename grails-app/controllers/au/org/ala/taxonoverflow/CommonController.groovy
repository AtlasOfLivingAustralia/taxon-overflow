package au.org.ala.taxonoverflow

import grails.converters.JSON

class CommonController {

    def ping() {
        render([status: 'ok'] as JSON)
    }
}
