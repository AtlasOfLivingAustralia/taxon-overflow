package au.org.ala.taxonoverflow

class TaxonOverflowTagLib {

    static namespace = "to"

    def pegDownService

    static defaultEncodeAs = [taglib:'none']
    static encodeAsForTags = [markdown: [taglib:'none']]

    /**
     * Body contains markdown
     */
    def markdown = { attrs, body ->
        out << pegDownService.markdown(body().trim())
    }

}
