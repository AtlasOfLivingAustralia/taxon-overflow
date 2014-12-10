package au.org.ala.taxonoverflow

import grails.converters.JSON
import grails.transaction.NotTransactional
import groovy.json.JsonSlurper
import org.codehaus.groovy.grails.web.servlet.mvc.GrailsParameterMap
import org.elasticsearch.action.delete.DeleteResponse
import org.elasticsearch.action.index.IndexResponse
import org.elasticsearch.action.search.SearchResponse
import org.elasticsearch.action.search.SearchType
import org.elasticsearch.client.Client
import org.elasticsearch.common.settings.ImmutableSettings
import org.elasticsearch.search.sort.SortOrder

import javax.annotation.PreDestroy
import java.util.concurrent.ConcurrentLinkedQueue

import static org.elasticsearch.node.NodeBuilder.nodeBuilder
import javax.annotation.PostConstruct
import org.elasticsearch.node.Node

class ElasticSearchService {

    private static final String INDEX_NAME = "taxonoverflow"

    // Consider using a priority queue so delete operations can be push through with higher priority?
    private static Queue<IndexQuestionTask> _backgroundQueue = new ConcurrentLinkedQueue<IndexQuestionTask>()

    def grailsApplication
    private Node node
    private Client client

    @NotTransactional
    @PostConstruct
    def initialize() {
        log.info("ElasticSearch service starting...")
        ImmutableSettings.Builder settings = ImmutableSettings.settingsBuilder();
        settings.put("path.home", grailsApplication.config.elasticsearch.location);
        node = nodeBuilder().local(true).settings(settings).node();
        client = node.client();
        client.admin().cluster().prepareHealth().setWaitForYellowStatus().execute().actionGet();
        log.info("ElasticSearch service initialisation complete.")
    }

    @NotTransactional
    @PreDestroy
    def destroy() {
        if (node) {
            node.close();
        }
    }

    @NotTransactional
    public reinitialiseIndex() {
        try {
            node.client().admin().indices().prepareDelete(INDEX_NAME).execute().get()
        } catch (Exception ex) {
            println ex
            // failed to delete index - maybe because it didn't exist?
        }
        addMappings()
    }

    @NotTransactional
    public void indexQuestion(Question question) {
        println "Indexing question " + question?.id
        String json = question as JSON

        if (json) {
            deleteQuestionFromIndex(question)
            IndexResponse response = client.prepareIndex(INDEX_NAME, "question", question.id.toString()).setSource(json).execute().actionGet();
        }
    }

    @NotTransactional
    public void deleteQuestionFromIndex(Question question) {
        if (question) {
            println "deleting question from index: ${question.id}"
            DeleteResponse response = client.prepareDelete(INDEX_NAME, "question", question.id.toString()).execute().actionGet();
        }
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

    public QueryResults<Question> executeSearch(GrailsParameterMap params, Closure builderFunc) {

        def searchRequestBuilder = client.prepareSearch(INDEX_NAME).setSearchType(SearchType.QUERY_THEN_FETCH)

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
        }

        println searchRequestBuilder

        SearchResponse searchResponse = searchRequestBuilder.execute().actionGet();

        def resultsList = []
        if (searchResponse.hits) {
            searchResponse.hits.each { hit ->
                resultsList << Question.get(hit.id.toLong())
            }
        }

        return new QueryResults<Question>(list: resultsList, totalCount: searchResponse?.hits?.totalHits ?: 0)
    }

}

