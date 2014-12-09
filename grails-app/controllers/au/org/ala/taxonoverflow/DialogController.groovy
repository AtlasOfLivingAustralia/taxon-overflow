package au.org.ala.taxonoverflow

class DialogController {

    def userService

    def areYouSureFragment() {
        def message = params.message
        def affirmativeText = params.affirmativeText ?: "Yes"
        def negativeText = params.negativeText ?: "No"

        [message: message, affirmativeText: affirmativeText, negativeText: negativeText]
    }

    def pleaseWaitFragment() {
        [message: params.message ?: "Please wait..."]
    }

    def editAnswerFragment() {
        def answer = Answer.get(params.int("answerId"))
        [answer: answer, user: userService.currentUser]
    }

    def addQuestionTagFragment() {
        def question = Question.get(params.int("questionId"))
        [question: question, user: userService.currentUser]
    }

}
