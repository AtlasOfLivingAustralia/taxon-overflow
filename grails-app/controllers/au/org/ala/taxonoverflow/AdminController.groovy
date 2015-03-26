package au.org.ala.taxonoverflow

import au.org.ala.web.AlaSecured
import grails.converters.JSON
import grails.converters.XML

@AlaSecured(value = "ROLE_ADMIN", redirectController = "question")
class AdminController {

    def elasticSearchService

    def index() {
        redirect(action:'dashboard')
    }

    def dashboard() {}

    def indexAdmin() {}

    def importFromEcodata(){}

    def createQuestionFromBiocache() { render view: 'createQuestion', model:[source:'biocache']}

    def createQuestionFromEcodata()  { render view: 'createQuestion', model:[source:'ecodata']}

    def ajaxReindexAll() {

        elasticSearchService.deleteAllQuestionsFromIndex()
        def c = Question.createCriteria()
        def questionIds = c.list {
            projections {
                property("id")
            }
        }

        questionIds?.each { questionId ->
            elasticSearchService.scheduleQuestionIndexation(questionId)
        }

        renderResults([success: true, questionCount: questionIds?.size() ?: 0])
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
}
