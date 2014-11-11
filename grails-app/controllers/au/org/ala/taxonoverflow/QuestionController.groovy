package au.org.ala.taxonoverflow

import static grails.async.Promises.*

class QuestionController {

    def questionService
    def biocacheService
    def imagesWebService

    def index() {
        redirect(action:'list')
    }

    def list() {
        params.max = params.max ?: 20
        def questions = Question.list(params)
        def totalCount = Question.count()
        [questions: questions, totalCount: totalCount]
    }

    def delete(int id) {
        def question = Question.get(id)
        if (question) {
            log.debug("Deleting question ${question?.id}")
            //question.delete(flush: true)
            questionService.deleteQuestion(question)
        } else {
            log.debug("Could not find question: ${id}")
            flash.message = "Failed to delete question id ${id}. Question not found."
        }
        redirect(action:'list')
    }

    def view(int id) {
        def question = Question.get(id)
        if (question) {

            def responsesPromise = task {
                Response.findAllByQuestion(question)
            }

            def specimenPromise = task {
                biocacheService.getRecord(question.occurrenceId)
            }

            waitAll(specimenPromise, responsesPromise)

            imagesWebService.getImageInfo()

            def specimen = specimenPromise.get()

            def imageIds = specimen?.images*.filePath

            println imageIds

            return [question: question, responses: responsesPromise.get(), imageIds: imageIds]
        } else {
            flash.message = "No such question, or question not specified"
            redirect(action:'list')
        }
    }

}
