package au.org.ala

import au.org.ala.taxonoverflow.ElasticSearchService
import grails.test.spock.IntegrationSpec

class ElasticSearchServiceIntegrationSpec extends IntegrationSpec {

    ElasticSearchService elasticSearchService

    def setup() {
    }

    def cleanup() {
    }

    void "test get aggregated tags"() {
        when:
        def results = elasticSearchService.getAggregatedTagsWithCount()
        then:
        if (results?.size() > 0) {
            results[0].label instanceof String
            results[0].count >= 1
        }
    }

    void "test get aggregated question types"() {
        when:
        def results = elasticSearchService.getAggregatedQuestionTypesWithCount()
        then:
        if (results?.size() > 0) {
            results[0].label instanceof String
            results[0].count >= 1
        }
    }
}
