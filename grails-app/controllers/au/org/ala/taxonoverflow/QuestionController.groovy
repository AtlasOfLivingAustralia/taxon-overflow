package au.org.ala.taxonoverflow

import static grails.async.Promises.*

class QuestionController {

    def questionService
    def biocacheService
    def imagesWebService
    def userService
    def authService

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

            def specimenPromise = task {
                biocacheService.getRecord(question.occurrenceId)
            }

            def userId = authService.userId

            waitAll(specimenPromise)

            def specimen = specimenPromise.get()
            def imageIds = specimen?.images*.filePath

            def acceptedAnswer = Answer.findByQuestionAndAccepted(question, true)

            return [question: question, imageIds: imageIds, occurrence: specimen, userId: userId, acceptedAnswer: acceptedAnswer]
        } else {
            flash.message = "No such question, or question not specified"
            redirect(action:'list')
        }
    }

    def createQuestion() {

    }

    def answersListFragment(int id) {
        def question = Question.get(id)
        def user = userService.currentUser
        List answers = []
        if (question) {
            def c = Answer.createCriteria()
            answers = c.list {
                eq("question", question)
                and {
                    order("accepted", "desc")
                    order("dateCreated", "asc")
                }
            }

            def votes = []
            if (answers) {
                c = AnswerVote.createCriteria()
                votes = c {
                    inList("answer", answers)
                    projections {
                        property("answer")
                        sum("voteValue")
                        groupProperty("answer")
                    }
                }
            }

            def answerVoteTotals = votes?.collectEntries { [ (it[0]) : it[1]] }
            def userVotes = AnswerVote.findAllByUserAndAnswerInList(user, answers)?.collectEntries { [ (it.answer) : it]}
            def userAnswers = Answer.findAllByQuestionAndUser(question, user)

            [answers: answers, question: question, user: user, answerVoteTotals: answerVoteTotals, userVotes: userVotes, userAnswers: userAnswers]
        }

    }

}
