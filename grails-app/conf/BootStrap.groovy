class BootStrap {

    def elasticSearchService

    def init = { servletContext ->
        // Reference the service to make sure it's loaded and initialised
        elasticSearchService.ping()
    }

    def destroy = {
    }
}
