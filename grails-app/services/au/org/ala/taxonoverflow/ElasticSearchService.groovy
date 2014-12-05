package au.org.ala.taxonoverflow

import grails.converters.JSON
import grails.transaction.NotTransactional
import groovy.json.JsonSlurper
import net.sf.ehcache.search.expression.Not
import org.codehaus.groovy.grails.web.servlet.mvc.GrailsParameterMap
import org.elasticsearch.action.delete.DeleteResponse
import org.elasticsearch.action.index.IndexResponse
import org.elasticsearch.action.search.SearchResponse
import org.elasticsearch.action.search.SearchType
import org.elasticsearch.client.Client
import org.elasticsearch.cluster.ClusterState
import org.elasticsearch.cluster.metadata.IndexMetaData
import org.elasticsearch.cluster.metadata.MappingMetaData
import org.elasticsearch.common.settings.ImmutableSettings
import org.elasticsearch.index.query.FilterBuilders
import org.elasticsearch.index.query.QueryBuilders

import javax.annotation.PreDestroy
import java.util.regex.Pattern

import static org.elasticsearch.node.NodeBuilder.nodeBuilder
import javax.annotation.PostConstruct
import org.elasticsearch.node.Node

class ElasticSearchService {

    private static final String INDEX_NAME = "TaxonOverflow"

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
        IndexResponse response = client.prepareIndex(INDEX_NAME, "question", question.id.toString()).setSource((question as JSON).toString()).execute().actionGet();
        println response
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
}
