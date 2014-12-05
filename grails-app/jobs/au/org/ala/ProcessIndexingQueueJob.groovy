package au.org.ala

class ProcessIndexingQueueJob {

    def elasticSearchService

    static triggers = {
      simple repeatInterval: 1000l // execute job once in 5 seconds
    }

    def execute() {
        try {
            elasticSearchService.processIndexTaskQueue()
        } catch (Exception ex) {
            ex.printStackTrace()
        }

    }
}
