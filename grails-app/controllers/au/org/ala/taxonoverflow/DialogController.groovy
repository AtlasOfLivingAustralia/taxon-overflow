package au.org.ala.taxonoverflow

class DialogController {

    def userService

    def addQuestionTagDialog(long id) {
        def question = Question.get(id)
        render template: 'questionTagDialog', model: [question: question, user: userService.currentUser]
    }

    def addAnswerDialog(long id) {
        def question = Question.get(id)
        render template: 'answerDialog', model: [question: question]
    }

    def addAnswerCommentDialog  (long id) {
        def answer = Answer.get(id)
        render template: 'answerCommentDialog', model: [answer: answer]
    }

}
