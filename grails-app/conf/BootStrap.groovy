import au.org.ala.taxonoverflow.ElasticSearchService

class BootStrap {

    def elasticSearchService
    def customJSONMarshallers
    def grailsApplication
    def sourceService

    def init = { servletContext ->
        log.info("System Notifications are ${grailsApplication.config.notifications.enabled ? 'ENABLED' : 'DISABLED'}")

        // Reference the service to make sure it's loaded and initialised
        elasticSearchService.ping()
        customJSONMarshallers.register()

        // Initialize source service
        sourceService.init()

        // Check if the taxonoverflow elastic search index is available
        log.info("Checking if the Elasticsearch \"${ElasticSearchService.INDEX_NAME}\" index is ready...")
        if (!elasticSearchService.isIndexReady()) {
            log.info("Initializing Elasticsearch \"${ElasticSearchService.INDEX_NAME}\" index...")
            if (elasticSearchService.initializeIndex()) {
                log.info("Elasticsearch \"${ElasticSearchService.INDEX_NAME}\" index is now ready")
            } else {
                log.error("Unable to initialize \"${ElasticSearchService.INDEX_NAME}\" index")
            }
        } else {
            log.info("Elasticsearch \"${ElasticSearchService.INDEX_NAME}\" index is now ready")
        }
    }

    def destroy = {
    }
}
