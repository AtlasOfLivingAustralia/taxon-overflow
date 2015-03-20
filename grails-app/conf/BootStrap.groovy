import au.org.ala.taxonoverflow.Source

class BootStrap {

    def elasticSearchService
    def customJSONMarshallers
    def grailsApplication
    def sourceService

    def init = { servletContext ->
        // Reference the service to make sure it's loaded and initialised
        elasticSearchService.ping()
        customJSONMarshallers.register()

        sourceService.init()
    }

    def destroy = {
    }
}
