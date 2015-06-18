package au.org.ala.taxonoverflow

class DialogController {

    def userService
    def elasticSearchService

    def addQuestionTagDialog(long id) {
        def question = Question.get(id)
        List<Map> tags = elasticSearchService.getAggregatedTagsWithCount()
        render template: 'questionTagDialog', model: [question: question, user: userService.currentUser, tags: tags.collect {tag -> tag.label}]
    }

    def addAnswerDialog(long id) {
        def question = Question.get(id)
        render template: 'answerDialog', model: [question: question]
    }

    def editAnswerDialog(long id) {
        def answer = Answer.get(id)
        render template: 'answerDialog', model: [question: answer.question, answer: answer]
    }

    def addAnswerCommentDialog  (long id) {
        def answer = Answer.get(id)
        render template: 'answerCommentDialog', model: [answer: answer]
    }

}
