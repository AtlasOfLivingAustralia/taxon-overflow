package au.org.ala.taxonoverflow

import org.elasticsearch.action.search.SearchRequestBuilder
import org.elasticsearch.index.query.FilterBuilders
import org.elasticsearch.index.query.QueryBuilders

import static grails.async.Promises.*

class QuestionController {

    def questionService
    def biocacheService
    def userService
    def authService
    def auditService
    def imagesWebService
    def elasticSearchService

    def index() {
        redirect(action:'list')
    }

    def list() {
        params.max = params.max ?: 20
        def questions = Question.list(params)
        def totalCount = Question.count()

        def occurrenceIds = questions*.occurrenceId

//        def qq = elasticSearchService.executeSearch(null) { SearchRequestBuilder builder ->
//            def filter = FilterBuilders.andFilter(
//                    FilterBuilders.queryFilter(QueryBuilders.simpleQueryString("tag:abc")),
//                    FilterBuilders.queryFilter(QueryBuilders.simpleQueryString("answers.accepted:true"))
//            )
//
//            builder.setPostFilter(filter)
//        }
//
//        println qq?.totalCount


        Map imageInfoMap = imagesWebService.getImageInfoForMetadata("occurrenceId", occurrenceIds)

        [questions: questions, totalCount: totalCount, imageInfoMap: imageInfoMap]
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

            def acceptedAnswer = Answer.findByQuestionAndAccepted(question, true)


            waitAll(specimenPromise)

            def specimen = specimenPromise.get()
            def imageIds = specimen?.images*.filePath

            auditService.logQuestionView(question)

            def viewCount = auditService.getQuestionViewCount(question)

            return [question: question, imageIds: imageIds, occurrence: specimen, userId: userId, acceptedAnswer: acceptedAnswer, viewCount: viewCount]
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

    def answerFragment(long id) {
        def answer = Answer.get(id)

        if (answer) {
            def user = userService.currentUser
            def userVote = AnswerVote.findByUserAndAnswer(user, answer)

            def c = AnswerVote.createCriteria()
            def totalVotes = c {
                eq("answer", answer)
                projections {
                    groupProperty("answer")
                    sum("voteValue")
                }
            }

            render(template: "answerFragment", model: [question: answer?.question, answer: answer, userVote: userVote, totalVotes: totalVotes ? totalVotes[0][1] : 0])
        }
    }

    def questionCommentsFragment(long id) {
        def question = Question.get(id)
        render(template:'questionCommentsFragment', model:[question: question])
    }

    def addAnswerCommentFragment(long id) {
        def answer = Answer.get(id)

        [answer: answer]
    }

    def addQuestionCommentFragment(long id) {
        def question = Question.get(id)
        [question: question]
    }

}
