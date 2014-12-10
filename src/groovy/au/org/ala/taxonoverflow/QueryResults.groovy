package au.org.ala.taxonoverflow

/**
 * For when you need to return both a page worth of results and the total count of record (for pagination purposes)
 *
 * @param < T > Usually a domain class. The type of objects being returned in the list
 */
class QueryResults <T> {

    public List<T> list = []
    public int totalCount = 0
}
