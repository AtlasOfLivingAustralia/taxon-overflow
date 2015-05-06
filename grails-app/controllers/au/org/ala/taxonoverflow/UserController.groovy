package au.org.ala.taxonoverflow

import au.org.ala.web.UserDetails

class UserController {
    def userService, authService, elasticSearchService

    def index() {
        def user = userService.currentUser

        if (user) {
            UserDetails userDetails = authService.getUserForUserId(user.alaUserId, true)
            List userAnswers = Answer.findAllByUser(user)
            [
                    user: user,
                    myQuestions: addImageMetaData(Question.findAllByUser(user)),
                    myAnsweredQuestions: addImageMetaData(getQuestionSetFromAnswers(userAnswers)),
                    userAnswersAccepted: userAnswers.findAll{it.accepted},
                    followedQuestions: addImageMetaData(user.followedQuestions),
                    userDetails: userDetails
            ]
        } else {
            render(status: 403, text: 'User not logged in or not recognised..')
        }
    }

    private addImageMetaData(def questions) {
        questions.eachWithIndex { q, i ->
            def rec =  elasticSearchService.getOccurrenceData(q.occurrenceId)
            log.debug "rec = ${rec}"
            // http://images.ala.org.au/store/2/5/8/e/e90caa4c-a0b7-4552-b4fb-6df415f6e852/thumbnail_square
            q.metaClass.imageUrls = rec?.imageUrls
            q.metaClass.imageIds = rec?.imageIds
        }
    }

    private def getQuestionSetFromAnswers(List<Answer> answers) {
        Set questions = []
        answers.each { a ->
            questions.add(a.question)
        }
        questions
    }
}
