package au.org.ala.taxonoverflow

class DialogController {

    def userService

    def addQuestionTagDialog() {
        def question = Question.get(params.int("questionId"))
        [question: question, user: userService.currentUser]
    }

    def addAnswerDialog() {

    }

}
