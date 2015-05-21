package au.org.ala.taxonoverflow

import com.nerderg.ajaxanywhere.AAUtils

import static grails.async.Promises.task
import static grails.async.Promises.waitAll

class QuestionController {

    def userService
    def authService
    def auditService
    def elasticSearchService
    def imagesWebService

    static int defaultPageSize = 20

    def index() {
        redirect(action:'list')
    }

    def list() {

        params.max = params.max ?: defaultPageSize
        params.sort = params.sort ?: 'dateCreated'
        params.order = params.order ?: 'desc'

        int questionsCount = Question.count()
        def searchResults = questionsCount > 0 ? elasticSearchService.questionSearch(params) : [:]

        def acceptedAnswers = [:]
        def c = Answer.createCriteria()
        if (searchResults?.list) {
            def l = c.list {
                inList("question", searchResults?.list)
                eq("accepted", true)
            }

            acceptedAnswers = l?.collectEntries {
                [(it.question): it]
            }
        }

        Map model = [questions: searchResults?.list, totalCount: searchResults?.totalCount, acceptedAnswers: acceptedAnswers,
                     occurrenceData: searchResults?.auxdata, tagsFollowing: userService.currentUser?.tags?.toList(), imagesServiceBaseUrl: imagesWebService.getServiceUrl() ]
        if (AAUtils.isAjaxAnywhereRequest(request)) {
            render template: 'questionsList', model: model
        } else {
            return model
        }

    }

    def view(int id) {
        def question = Question.get(id)

        if (question) {

            def specimenPromise = task {
                elasticSearchService.getOccurrenceData(question.occurrenceId)
            }

            def alaUserId = authService.userId

            def acceptedAnswer = Answer.findByQuestionAndAccepted(question, true)

            waitAll(specimenPromise)

            def specimen = specimenPromise.get()
            def imageIds = specimen?.images*.filePath

            auditService.logQuestionView(question)

            def viewCount = auditService.getQuestionViewCount(question)
            return [question: question, imageIds: imageIds, occurrence: specimen, userId: alaUserId,
                    acceptedAnswer: acceptedAnswer, viewCount: viewCount, imagesServiceBaseUrl: imagesWebService.getServiceUrl()]

        } else {
            flash.message = "No such question, or question not specified"
            redirect(action:'list')
        }
    }

    def questionComments(long id) {
        def question = Question.get(id)
        render(template:'questionComments', model:[question: question, userId: authService.userId])
    }

    def questionTagsFragment(long id) {
        def question = Question.get(id)
        render(template:'tagsFragment', model:[question: question])
    }

    def mapFragment(long id) {
        def question = Question.get(id)
        if (question) {
            def occurrence = elasticSearchService.getOccurrenceData(question.occurrenceId)
            def coordinates = OccurrenceHelper.getCoordinates(occurrence)
            render template:'mapFragment', model: [question: question, occurrence: occurrence, coordinates: coordinates]
        }
    }

    def showAggregatedTags() {
        List<Map> tags = elasticSearchService.getAggregatedTagsWithCount()
        render template: 'aggregatedTags', model: [tags: tags, tagsFollowing: userService.currentUser?.tags?.toList()]
    }

    def showAggregatedQuestionTypes() {
        List<Map> tags = elasticSearchService.getAggregatedQuestionTypesWithCount()
        render template: 'aggregatedQuestionTypes', model: [questionTypes: tags]
    }

    def followingFragment(int id) {
        Question question = Question.get(id)
        def alaUserId = authService.userId
        User user = User.findByAlaUserId(alaUserId)
        boolean isFollowing = user ? user.followedQuestions?.contains(question) : false;

        render template: 'followingFragment', model: [question: question, isFollowing: isFollowing]
    }

    def answers(int id) {
        def question = Question.get(id)
        def user = userService.currentUser
        List answers = []
        if (question) {
            def criteria = Answer.createCriteria()
            answers = criteria.list {
                eq("question", question)
                and {
                    order("accepted", "desc")
                    order("dateCreated", "asc")
                }
            }

            def votes = []
            if (answers) {
                criteria = AnswerVote.createCriteria()
                votes = criteria {
                    inList("answer", answers)
                    projections {
                        property("answer")
                        sum("voteValue")
                        groupProperty("answer")
                    }
                }
            }

            def answerVoteTotals = votes?.collectEntries { [(it[0]): it[1]] }
            def userVotes = AnswerVote.findAllByUserAndAnswerInList(user, answers)?.collectEntries { [(it.answer): it] }
            def userAnswers = Answer.findAllByQuestionAndUser(question, user)

            render template: 'answers', model: [answers: answers, question: question, user: user, answerVoteTotals: answerVoteTotals, userVotes: userVotes, userAnswers: userAnswers]
        }
    }
}