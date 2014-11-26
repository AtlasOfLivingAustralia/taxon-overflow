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
        def userId = authService.userId
        if (question) {

            def specimenPromise = task {
                biocacheService.getRecord(question.occurrenceId)
            }

            waitAll(specimenPromise)

            def specimen = specimenPromise.get()
            def imageIds = specimen?.images*.filePath

            println specimen.processed

            return [question: question, imageIds: imageIds, occurrence: specimen, userId: userId]
        } else {
            flash.message = "No such question, or question not specified"
            redirect(action:'list')
        }
    }

    def createQuestion() {

    }

    def createQuestionFromOccurrenceId() {

        def occurrenceId = params.occurrenceId as String
        def user = userService.currentUser

        if (!user) {
            flash.message = "Not logged in or a configuration error has occurred. No current user object!"
            redirect(uri: '/')
            return

        }

        if (!occurrenceId) {
            flash.message = "You must supply an occurrence id from the biocache!"
            redirect(action: 'createQuestion')
            return
        }

        def questionType = params.questionType as QuestionType ?: QuestionType.Identification
        def tags = params.tags?.split(",").toList()

        def question = questionService.createQuestionFromOccurrence(occurrenceId, questionType, tags, user)

        if (!question) {
            flash.message = "Failed to create question for occurrence id ${occurrenceId}"
        }

        redirect(action:'list')
    }

    def answersListFragment(int id) {
        def question = Question.get(id)
        def user = userService.currentUser
        def answers = []
        if (question) {
            def c = Answer.createCriteria()
            answers = c.list {
                eq("question", question)
                and {
                    order("accepted", "desc")
                    order("dateCreated", "asc")
                }
            }

        }
        [answers: answers, question: question, currentUserId: user.alaUserId]
    }

    def ajaxSubmitAnswer(int id) {
        def userId
    }

}
