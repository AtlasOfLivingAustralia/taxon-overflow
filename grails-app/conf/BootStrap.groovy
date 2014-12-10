class BootStrap {

    def elasticSearchService
    def customJSONMarshallers

    def init = { servletContext ->
        // Reference the service to make sure it's loaded and initialised
        elasticSearchService.ping()
        customJSONMarshallers.register()
    }

    def destroy = {
    }
}
