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
     * @attr occurrence
     * @attr name
     * @attr title
     */
    def occurrenceProperty = { attrs, body ->
        def occurrence = attrs.occurrence as JSONObject
        def name = attrs.name as String
        def title = attrs.title as String ?: name
        def rawValue = Ognl.getValue("raw.${name}", occurrence)
        def processedValue = Ognl.getValue("processed.${name}", occurrence)
        if (processedValue || rawValue) {
            def mb = new MarkupBuilder(out)
            mb.div(class:'row-fluid') {
                mb.div(class:'span4 occurrence-property-name') {
                    mkp.yield(title)
                }
                mb.div(class:'span8 occurrence-property-value') {
                    mkp.yield(processedValue ?: rawValue)
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
     * @attr question
     */
    def ifCanEditQuestion = { attrs, body ->
        def question = attrs.question as Question
        if (question) {
            if (questionService.canUserEditQuestion(question, userService.currentUser)) {
                out << body()
            }
        }
    }

    /**
     * @attr question
     */
    def ifCannotEditQuestion = { attrs, body ->
        def question = attrs.question as Question
        if (question) {
            if (!questionService.canUserEditQuestion(question, userService.currentUser)) {
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

    /**
     * @attr active
     * @attr title
     * @attr href
     */
    def menuNavItem = { attrs, body ->
        def active = attrs.active
        if (!active) {
            active = attrs.title
        }
        def current = pageProperty(name:'page.pageTitle')?.toString()

        def mb = new MarkupBuilder(out)
        mb.li(class: active == current ? 'active' : '') {
            a(href:attrs.href) {
                mkp.yield(attrs.title)
            }
        }
    }

    def navSeparator = { attrs, body ->
        out << "&nbsp;&#187;&nbsp;"
    }

}

