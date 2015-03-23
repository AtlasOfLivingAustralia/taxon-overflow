package au.org.ala.taxonoverflow

class UserController {
    def userService, authService, elasticSearchService

    def index() {
        def user = userService.currentUser
        //def searchResults = elasticSearchService.getOccurrenceData()
        log.debug "User controller: ${user}"

        if (user) {
            user.metaClass.displayName = authService.getDisplayName()
            [
                    user: user,
                    myQuestions: addImageMetaData(Question.findAllByUser(user)),
                    myAnsweredQuestions: addImageMetaData(getQuestionSetFromAnswers(Answer.findAllByUser(user))),
                    followedQuestions: addImageMetaData(user.followedQuestions)
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
            q.metaClass.imageUrls = rec.imageUrls
            q.metaClass.imageIds = rec.imageIds
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
