package au.org.ala.taxonoverflow

import groovy.xml.MarkupBuilder
import net.sf.json.JSONObject
import ognl.Ognl

class TaxonOverflowTagLib {

    static namespace = "to"

    def markdownService
    def authService
    def userService
    def questionService

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

            def values = []

            names.each {
                def name = (it as String).trim()
                def rawValue = Ognl.getValue("raw${attrs.section ? ('.' + attrs.section) : ''}.${name}", occurrence)
                def processedValue = Ognl.getValue("processed${attrs.section ? ('.' + attrs.section) : ''}.${name}", occurrence)
                if (processedValue || rawValue) {
                    values << [name: name, processed: processedValue, raw: rawValue]
                }
            }


            if (values) {
                mb.table(class: 'table table-bordered table-condensed table-striped') {
                    thead {
                        tr {
                            th(colspan: '2') {
                                mkp.yield(attrs.title ?: attrs.section)
                            }
                        }
                    }
                    tbody {
                        values.each { valuemap ->
                            mb.tr {
                                td(style: 'width: 200px') {
                                    mkp.yield(valuemap.name)
                                }
                                td {
                                    mkp.yield(valuemap.processed ?: valuemap.raw ?: '')
                                }
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
        out << "Logged in as " + authService.userDetails().userDisplayName
    }

    /**
     * @attr user
     */
    def userDisplayName = { attrs, body ->
        def user = attrs.user as User
        def userDetails = authService.getUserForUserId(user?.alaUserId)
        out << userDetails?.displayName ?:  user?.alaUserId
    }

    def currentUserId = { attrs, body ->
        def user = userService.currentUser
        out << user?.alaUserId
    }

    /**
     * @attr answer
     */
    def ifCanEditAnswer = { attrs, body ->
        def answer = attrs.answer as Answer
        if (answer) {
            if (answer.user == userService.currentUser) {
                out << body()
            }
        }
    }

    /**
     * @attr answer
     */
    def ifCanAcceptAnswer = { attrs, body ->
        def answer = attrs.answer as Answer
        if (answer) {
            if (questionService.canUserAcceptAnswer(answer, userService.currentUser)) {
                out << body()
            }
        }
    }

    /**
     * @attr answer
     */
    def ifCannotAcceptAnswer = { attrs, body ->
        def answer = attrs.answer as Answer
        if (answer) {
            if (!questionService.canUserAcceptAnswer(answer, userService.currentUser)) {
                out << body()
            }
        }
    }

    /**
     * @attr title alt text
     */
    def spinner = { attrs, body ->
        def url = "${createLink(uri:'/images/spinner.gif')}"
        out << "<img src=\"${url}\" alt=\"${attrs.title ?: "Loading..."}\" />"
    }

    /**
     * @attr comment
     */
    def ifCanEditComment = { attrs, body ->
        def comment = attrs.comment as Comment
        if (comment) {
            if (comment.user == userService.currentUser) {
                out << body()
            }
        }
    }

}

