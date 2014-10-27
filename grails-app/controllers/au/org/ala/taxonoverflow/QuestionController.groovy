package au.org.ala.taxonoverflow

class QuestionController {

    def questionService

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
            def responses = Response.findAllByQuestion(question)
            return [question: question, responses: responses]
        } else {
            flash.message = "No such question, or question not specified"
            redirect(action:'list')
        }
    }

}
