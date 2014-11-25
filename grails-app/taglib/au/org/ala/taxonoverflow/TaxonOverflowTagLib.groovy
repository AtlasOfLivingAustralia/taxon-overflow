package au.org.ala.taxonoverflow

import groovy.xml.MarkupBuilder
import net.sf.json.JSONObject
import ognl.Ognl

class TaxonOverflowTagLib {

    static namespace = "to"

    def markdownService
    def authService

    static defaultEncodeAs = [taglib:'none']
    static encodeAsForTags = [markdown: [taglib:'none']]

    /**
     * Body contains markdown
     */
    def markdown = { attrs, body ->
        out << markdownService.markdown(body().trim())
    }

    /**
     * @attr title
     * @attr section
     * @attr names
     * @attr occurrence
     */
    def occurrencePropertiesTable = { attrs, body ->
        def occurrence = attrs.occurrence as JSONObject
        def names = attrs.names?.split(",")?.toList()
        if (occurrence && names) {
            def mb = new MarkupBuilder(out)

            mb.table(class:'table table-bordered table-condensed table-striped') {
                thead {
                    tr {
                        th(colspan:'2') {
                            mkp.yield(attrs.title ?: attrs.section)
                        }
                    }
                }
                tbody {
                    names.each {
                        def name = (it as String).trim()
                        mb.tr {
                            td {
                                mkp.yield(name)
                            }
                            td {
                                mkp.yield(Ognl.getValue("processed.${attrs.section}.${name}", occurrence) ?: Ognl.getValue("raw.${attrs.section}.${name}", occurrence))
                            }
                        }
                    }
                }
            }
        }

    }

    /**
     * @attr question
     * @attr answer (optional)
     */
    def renderAnswerTemplate =  {attrs, body ->
        def question = attrs.question as Question

        if (!question) {
            out << "No question specified!"
            return
        }

        def html = render(template: "/question/edit${question.questionType.toString()}Answer", model: [question: question, answer: attrs.answer as Answer])

        out << html
    }

    def userContext = { attrs, body ->
        out << authService.userDetails().toString()
    }


}
