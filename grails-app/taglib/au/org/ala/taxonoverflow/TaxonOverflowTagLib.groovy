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
        if (occurrence) {
            def name = attrs.name as String
            def title = attrs.title as String ?: name
            def value = occurrence."${name}"
            if(value){
                def mb = new MarkupBuilder(out)
                mb.div(class: 'row-fluid') {
                    mb.div(class: 'span3 occurrence-property-name') {
                        mkp.yield(title)
                    }
                    mb.div(class: 'span9 occurrence-property-value') {
                        mkp.yield(occurrence."${name}")
                    }
                }
            }
        }
    }

    def switchUserLink = { attrs, body ->
        def logOutLink = createLink(controller: "logout", action: "logout")
        def casUrl = grailsApplication.config.casServerUrlPrefix + "/logout"
        def appUrl = URLEncoder.encode(grailsApplication.config.casServerLoginUrl + "?email=" + attrs.email + "&service=" + grailsApplication.config.serverName + request.forwardURI, "UTF-8")
        out << """<a href="${logOutLink}?casUrl=${casUrl}&appUrl=${appUrl}">${attrs.email}</a>"""
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

        def html = render(template: "/question/edit${question.questionType.getCamelCaseName()}Answer", model: [question: question, answer: attrs.answer as Answer])

        out << html
    }

    def userContext = { attrs, body ->
        def userDetails = authService.userDetails()
        if(userDetails) {
            out << "Logged in as " + userDetails.userDisplayName
        }
    }

    /**
     * @attr user
     */
    def userDisplayName = { attrs, body ->
        def user = attrs.user as User
        def userDetails = authService.getUserForUserId(user?.alaUserId)
        out << userDetails?.displayName ?:  user?.alaUserId
    }

    def currentUserDisplayName = { attrs, body ->
        def user = userService.currentUser
        def userDetails = authService.getUserForUserId(user?.alaUserId)
        if(userDetails) {
            out << userDetails?.displayName
        }
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

    /**
     * Generate the URL to the original|thumb version of the images
     * based on the imageId
     *
     * E.g. http://images.ala.org.au/store/2/5/8/e/e90caa4c-a0b7-4552-b4fb-6df415f6e852/thumbnail_square
     *
     * @attr imageId REQUIRED
     * @attr fallbackUrl - if URL can't be generated use this URL as fallback
     * @attr imageFormat - one of original|thumbnail|thumbnail_large|thumbnail_square|thumbnail_square_black|thumbnail_square_darkGray|thumbnail_square_white
     */
    def getImageUrlForImageId = { attrs, body ->
        String url = attrs.fallbackUrl?:""
        def imageId = attrs.imageId
        def imageFormat = attrs.imageFormat?:'thumbnail' // original
        if (imageId && imageId.size() > 10) {
            def directoryList = imageId[-1..-4].split('') //  get first 4 directories
            url = "${grailsApplication.config.ala.image.service.url}/store" + directoryList.join("/") + "/${imageId}/" + imageFormat
        }
        out << url
    }

}

