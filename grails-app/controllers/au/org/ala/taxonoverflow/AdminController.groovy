package au.org.ala.taxonoverflow

import au.org.ala.web.AlaSecured
import au.org.ala.web.UserDetails
import grails.converters.JSON
import grails.converters.XML

@AlaSecured(value = "ROLE_ADMIN", redirectController = "question")
class AdminController {

    def elasticSearchService
    def authService

    def index() {
        redirect(action:'dashboard')
    }

    def dashboard() {}

    def indexAdmin() {}

    def importFromEcodata(){}

    def createQuestionFromBiocache() { render view: 'createQuestion', model:[source:'biocache']}

    def createQuestionFromEcodata()  { render view: 'createQuestion', model:[source:'ecodata']}

    def ajaxReindexAll() {
        renderResults(elasticSearchService.reIndexAllQuestions())
    }

    private renderResults(Object results, int responseCode = 200) {

        withFormat {
            json {
                def jsonStr = results as JSON
                if (params.callback) {
                    render("${params.callback}(${jsonStr})")
                } else {
                    render(jsonStr)
                }
            }
            xml {
                render(results as XML)
            }
        }
        response.addHeader("Access-Control-Allow-Origin", "")
        response.status = responseCode
    }

    def previewNotifications() {
        def comments = Comment.list(sort: 'dateCreated', order: 'desc', max: 5)
        def answers = Answer.list(sort: 'dateCreated', order: 'desc', max: 5)
        def tags = QuestionTag.list(sort: 'dateCreated', order: 'desc', max: 5)

        render view: 'previewNotifications', model: [comments: comments, answers: answers, tags: tags]
    }

    def previewQuestionCommentNotification() {
        Comment comment;
        if (params.type == '1') {
            comment = QuestionComment.get(params.int('id'))
        } else if (params.type == '2') {
            comment = AnswerComment.get(params.int('id'))
        }
        UserDetails userDetails = authService.getUserForUserId(comment.user?.alaUserId)
        render template: '/notifications/newCommentNotification', model: [comment: comment, userDetails: userDetails]
    }

    def previewAnswerNotification() {
        Answer answer = Answer.get(params.int('id'))
        UserDetails userDetails = authService.getUserForUserId(answer.user?.alaUserId)
        render template: '/notifications/answerNotification', model: [answer: answer, userDetails: userDetails]
    }

    def previewTagNotification() {
        QuestionTag questionTag = QuestionTag.get(params.int('id'))
        render template: '/notifications/newTagNotification', model: [questionTag: questionTag]
    }
}
