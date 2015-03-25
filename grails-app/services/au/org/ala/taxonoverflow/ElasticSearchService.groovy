package au.org.ala.taxonoverflow

import grails.converters.JSON
import grails.transaction.NotTransactional
import groovy.json.JsonSlurper
import io.searchbox.client.JestClient
import io.searchbox.client.JestClientFactory
import io.searchbox.client.config.HttpClientConfig
import io.searchbox.core.Search
import io.searchbox.core.SearchResult
import net.sf.json.JSONObject
import org.codehaus.groovy.grails.web.servlet.mvc.GrailsParameterMap
import org.elasticsearch.action.admin.indices.delete.DeleteIndexRequest
import org.elasticsearch.action.admin.indices.delete.DeleteIndexResponse
import org.elasticsearch.action.admin.indices.refresh.RefreshRequest
import org.elasticsearch.action.delete.DeleteResponse
import org.elasticsearch.action.index.IndexResponse
import org.elasticsearch.action.search.SearchRequestBuilder
import org.elasticsearch.action.search.SearchResponse
import org.elasticsearch.action.search.SearchType
import org.elasticsearch.client.Client
import org.elasticsearch.common.settings.ImmutableSettings
import org.elasticsearch.index.query.FilterBuilders
import org.elasticsearch.node.Node
import org.elasticsearch.search.sort.SortOrder

import javax.annotation.PostConstruct
import javax.annotation.PreDestroy
import java.util.concurrent.ConcurrentLinkedQueue

import static org.elasticsearch.node.NodeBuilder.nodeBuilder

class ElasticSearchService {

    private static final String INDEX_NAME = "taxonoverflow"

    // Consider using a priority queue so delete operations can be push through with higher priority?
    private static Queue<IndexQuestionTask> _backgroundQueue = new ConcurrentLinkedQueue<IndexQuestionTask>()

    def grailsApplication
    private Node node
    private Client client
    private JestClient jestClient
    private boolean isLoggingEnabled = false

    @NotTransactional
    @PostConstruct
    def initialize() {
        log.info("ElasticSearch service starting...")
        ImmutableSettings.Builder settings = ImmutableSettings.settingsBuilder();
        Map elasticsearchSettings = flatten(grailsApplication.config.elasticsearch)
        elasticsearchSettings?.each {setting, value ->
            if (setting != "logging.json") {
                settings.put(setting, value)
            } else {
                isLoggingEnabled = value
            }
        }
        node = nodeBuilder().local(true).settings(settings).node();
        client = node.client();
        client.admin().cluster().prepareHealth().setWaitForYellowStatus().execute().actionGet();
        JestClientFactory factory = new JestClientFactory();
        factory.setHttpClientConfig(new HttpClientConfig.Builder("http://localhost:9200")
                .multiThreaded(true)
                .build());
        jestClient = factory.getObject();
        log.info("ElasticSearch service initialisation complete.")

    }

    /**
     * Flatens map entries using dot notation
     * @param map
     * @param separator
     * @return
     */
    Map flatten(Map map, String separator = '.') {
        map.collectEntries { k, v -> v instanceof Map ? flatten(v, separator).collectEntries { q, r -> [(k + separator + q): r] } : [(k): v] }
    }

    @NotTransactional
    @PreDestroy
    def destroy() {
        if (jestClient) {
            jestClient.shutdownClient();
        }
        if (node) {
            node.close();
        }
    }

    @NotTransactional
    void refreshIndex() {
        node.client().admin().indices().refresh(new RefreshRequest(INDEX_NAME))
    }

    @NotTransactional
    void reinitialiseIndex() {
        try {
            node.client().admin().indices().prepareDelete(INDEX_NAME).execute().get()
        } catch (Exception ex) {
            println ex
            // failed to delete index - maybe because it didn't exist?
        }
        addMappings()
    }

    @NotTransactional
    void indexQuestion(Question question) {
        def ct = new CodeTimer("Indexing question ${question.id}")
        String json = question as JSON
        if (json) {
            IndexResponse response = client.prepareIndex(INDEX_NAME, "question", question.id.toString()).setSource(json).execute().actionGet();
        }
        ct.stop(true)
    }

    @NotTransactional
    void deleteAllQuestionsFromIndex() {
        def ct = new CodeTimer("Deleting questions from index")
        DeleteIndexResponse delete = client.admin().indices().delete(new DeleteIndexRequest(INDEX_NAME)).actionGet()
        ct.stop(true)
    }

    @NotTransactional
    void deleteQuestionFromIndex(Question question) {
        def ct = new CodeTimer("Deleting question from index: ${question.id}")
        if (question) {
            DeleteResponse response = client.prepareDelete(INDEX_NAME, "question", question.id.toString()).execute().actionGet();
        }
        ct.stop(true)
    }

    @NotTransactional
    def addMappings() {
        log.info("Adding index mappings")
        def mappingJson = '''
        {
            "mappings": {
            }
        }
        '''

        def parsedJson = new JsonSlurper().parseText(mappingJson)
        def mappingsDoc = (parsedJson as JSON).toString()
        client.admin().indices().prepareCreate(INDEX_NAME).setSource(mappingsDoc).execute().actionGet()
        client.admin().cluster().prepareHealth().setWaitForYellowStatus().execute().actionGet()
    }

    @NotTransactional
    def ping() {
        log.info("ElasticSearch Service is ${node ? '' : 'NOT' } alive.")
    }

    static def scheduleQuestionIndexation(long questionId) {
        _backgroundQueue.add(new IndexQuestionTask(questionId, IndexOperation.Update))
    }

    static def scheduleQuestionDeletion(long questionId) {
        _backgroundQueue.add(new IndexQuestionTask(questionId, IndexOperation.Delete))
    }

    @NotTransactional
    def processIndexTaskQueue(int maxQuestions = 10000) {
        int questionCount = 0
        IndexQuestionTask jobDescriptor = null

        while (questionCount < maxQuestions && (jobDescriptor = _backgroundQueue.poll()) != null) {
            if (jobDescriptor) {
                Question question = Question.get(jobDescriptor.questionId)
                if (question) {
                    switch (jobDescriptor.indexOperation) {
                        case IndexOperation.Delete:
                            deleteQuestionFromIndex(question)
                            break;
                        case IndexOperation.Insert:
                        case IndexOperation.Update:
                            indexQuestion(question)
                            break;
                        default:
                            throw new Exception("Unhandled operation type: ${jobDescriptor.indexOperation}")
                    }
                }
                questionCount++
            }
        }
    }

    QueryResults<Question> questionSearch(GrailsParameterMap params, Closure builderFunc = null) {

        SearchRequestBuilder searchRequestBuilder = client.prepareSearch(INDEX_NAME).setSearchType(SearchType.QUERY_THEN_FETCH)

        if (params?.offset) {
            searchRequestBuilder.setFrom(params.int("offset"))
        }

        if (params?.max) {
            searchRequestBuilder.setSize(params.int("max"))
        } else {
            searchRequestBuilder.setSize(Integer.MAX_VALUE) // probably way too many!
        }

        if (params?.sort) {
            def order = params?.order == "asc" ? SortOrder.ASC : SortOrder.DESC
            searchRequestBuilder.addSort(params.sort as String, order)
        }

        if (builderFunc) {
            ESFilterDSL.build(searchRequestBuilder, builderFunc)
        } else {
            if (params.q) {
                ESFilterDSL.build(searchRequestBuilder) {
                    q(params.q)
                }
            }
        }

        // Apply question tags and question types filter
        if (params?.f?.tags || params?.f?.types) {
            def filter = FilterBuilders.andFilter()
            if (params.f?.tags) {
                filter.add(FilterBuilders.orFilter(
                        FilterBuilders.termsFilter("tags.tag", params.f.tags.split(','))
                ))
            }

            if (params.f?.types) {
                filter.add(FilterBuilders.orFilter(
                        FilterBuilders.termsFilter("questionType", params.f.types.split(','))
                ))
            }
            searchRequestBuilder.setPostFilter(filter)
        }

        SearchResponse searchResponse = searchRequestBuilder.execute().actionGet();
        log.debug("ElasticSearch Query using Java Client API:\n${searchRequestBuilder.internalBuilder().toString()}")

        def resultsList = []
        def auxdata = [:]
        if (searchResponse.hits) {
            searchResponse.hits.each { hit ->
                def question  = Question.get(hit.id.toLong())
                if(question) {
                    //if null, DB out of sync with index
                    resultsList << Question.get(hit.id.toLong())
                }
                def map = hit.sourceAsMap()
                auxdata[map.occurrenceId] = map.occurrence
            }
        }

        return new QueryResults<Question>(list: resultsList, totalCount: searchResponse?.hits?.totalHits ?: 0, auxdata: auxdata)
    }

    JSONObject getOccurrenceData(String occurrenceId) {
        def results = questionSearch(null) {
            q("occurrenceId:\"${occurrenceId}\"")
        }

        if (results.totalCount > 0) {
            return results.auxdata[occurrenceId] as JSONObject
        }

        return null
    }

    @NotTransactional
    List<Map> getAggregatedTagsWithCount() {
        def query =
"""
{
    "size": 0,
    "aggs": {
        "tags": {
            "terms": {"field": "tags.tag"}
        }
    }
}
"""
        def tags = excuteRestApiQuery(query)?.jsonObject?.aggregations?.tags?.buckets
        tags.collect {tag ->
            [label: tag.key.getAsString(), count: tag.doc_count.getAsInt()]
        }
    }

    @NotTransactional
    List<Map> getAggregatedQuestionTypesWithCount() {
        def query =
"""
{
    "size": 0,
    "aggs": {
        "questionTypes": {
            "terms": {"field": "questionType"}
        }
    }
}
"""
        def questionTypes = excuteRestApiQuery(query)?.jsonObject?.aggregations?.questionTypes?.buckets
        questionTypes.collect {questionType ->
            [label: questionType.key.getAsString(), count: questionType.doc_count.getAsInt()]
        }
    }

    /**
     *
     * @param searchParams
     * @return
     */
    List<String> searchByTagsAndDatedCriteria(Map searchParams) {
        SearchRequestBuilder searchRequestBuilder = client.prepareSearch(INDEX_NAME).setSearchType(SearchType.QUERY_THEN_FETCH)
        .setNoFields()
        .setPostFilter(
                FilterBuilders.andFilter(
                        FilterBuilders.termsFilter("tags.tag", searchParams.tags.split(",").collect{it.trim()}).execution("and"),
                        FilterBuilders.orFilter(
                                *searchParams.criteria.searchFields.collect { String searchField ->
                                    FilterBuilders.rangeFilter(searchField).gte(searchParams.date)
                                }
                        )
                )
        )

        def hits = searchRequestBuilder.execute().actionGet()?.hits?.hits
        if (isLoggingEnabled) {
            log.debug("ElasticSearch Query using Java Client API:\n${searchRequestBuilder.internalBuilder().toString()}")
        }
        return hits.collect {hit -> hit.id}
    }

    /**
     * Performs a search on elasticsearch using the REST API
     * @param query
     * @param indexName [optional] taxonoverlfow index by default
     * @return
     */
    SearchResult excuteRestApiQuery(String query, String indexName = INDEX_NAME) {
        Search search = new Search.Builder(query).addIndex(indexName).build()
        if (isLoggingEnabled) {
            log.debug("ElasticSearch Query using REST API:\n ${query}")
        }
        jestClient.execute(search)
    }

}

