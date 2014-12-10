package au.org.ala.taxonoverflow

import org.elasticsearch.action.search.SearchRequestBuilder
import org.elasticsearch.index.query.AndFilterBuilder
import org.elasticsearch.index.query.FilterBuilder
import org.elasticsearch.index.query.FilterBuilders
import org.elasticsearch.index.query.OrFilterBuilder
import org.elasticsearch.index.query.QueryBuilders
import org.elasticsearch.search.sort.SortOrder

/**
 * Represents a Groovy DSL that can be used to construct complex filter queries against Elastic Search
 */
class ESFilterDSL {

    private _aggregator = []
    private SearchRequestBuilder _searchRequestBuilder

    private ESFilterDSL(SearchRequestBuilder searchRequestBuilder) {
        _searchRequestBuilder = searchRequestBuilder
    }

    def static build(SearchRequestBuilder searchRequestBuilder, Closure closure) {
        def context = new ESFilterDSL(searchRequestBuilder)
        closure.delegate = context
        closure()
        if (context._aggregator) {
            searchRequestBuilder.setPostFilter(FilterBuilders.andFilter(context._aggregator as FilterBuilder[]))
        }
    }

    public SearchRequestBuilder getSrb() {
        return _searchRequestBuilder
    }

    public AndFilterBuilder and(Closure closure) {
        def context = new ESFilterDSL(_searchRequestBuilder)
        closure.delegate = context
        closure()
        return FilterBuilders.andFilter(context._aggregator as FilterBuilder[])
    }

    public OrFilterBuilder or(Closure closure) {
        def context = new ESFilterDSL(_searchRequestBuilder)
        closure.delegate = context
        closure()
        return FilterBuilders.orFilter(context._aggregator as FilterBuilder[])
    }

    public void q(String q) {
        _aggregator << FilterBuilders.queryFilter(QueryBuilders.queryString(q))
    }

    public void filter(Closure<FilterBuilder> closure) {
        closure.delegate = new ESFilterDSL(_searchRequestBuilder)
        def filter = closure()
        _searchRequestBuilder.setPostFilter(filter)
    }

    public void sort(String field, SortOrder order) {
        _searchRequestBuilder.addSort(field, order)
    }

}
