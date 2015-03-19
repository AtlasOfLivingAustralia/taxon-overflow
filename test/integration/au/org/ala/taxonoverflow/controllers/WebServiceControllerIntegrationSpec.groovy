package au.org.ala.taxonoverflow.controllers

import au.org.ala.taxonoverflow.ElasticSearchService
import au.org.ala.taxonoverflow.Question
import au.org.ala.taxonoverflow.QuestionService
import au.org.ala.taxonoverflow.QuestionType
import au.org.ala.taxonoverflow.User
import au.org.ala.taxonoverflow.UserService
import au.org.ala.taxonoverflow.WebServiceController
import grails.test.spock.IntegrationSpec
import spock.lang.Shared

class WebServiceControllerIntegrationSpec extends IntegrationSpec {

    static final ISO_8601_DATE_FORMAT = 'yyyy-MM-dd'

    @Shared User userMick
    @Shared User userKeef
    @Shared WebServiceController controller = new WebServiceController()
    @Shared QuestionService questionService
    @Shared UserService userService
    @Shared ElasticSearchService elasticSearchService

    def setupSpec() {
        // Initialize users
        userMick = userService.getUserFromUserId('11841')
        userKeef = userService.getUserFromUserId('11842')
    }

    def setup() {
        // Clean elasticsearch index
        elasticSearchService.reinitialiseIndex()

        // Initialize the DB
        // 1st question
        questionService.createQuestionFromOccurrence(
                '181718e6-fd3b-4a1b-8b40-3f83fd2965e5',
                QuestionType.IDENTIFICATION,
                ['kangaroo', 'grey'],
                userMick,
                '1st question 1st comment'
        )
        // 2nd question
        questionService.createQuestionFromOccurrence(
                'b185ec97-7155-4207-b8c1-b0f64244f1a7',
                QuestionType.IDENTIFICATION,
                ['kangaroo', 'brown'],
                userKeef,
                '2nd question 1st comment'
        )
        // 3rd question
        questionService.createQuestionFromOccurrence(
                'c9e9589c-383e-4629-8f80-ea7588c4ccb2',
                QuestionType.IDENTIFICATION,
                ['parrot'],
                userMick,
                '3rd question 1st comment'
        )

        elasticSearchService.processIndexTaskQueue()
    }

    def cleanup() {

    }

    void "test DB has been initialized"() {
        when:
        List<Question> questionList = Question.findAll()

        then:
        questionList.size() > 0
    }

    void "test adding a new question from biocache occurrence"() {
        given:
        Integer initialNumberOfQuestions = Question.count

        when:
        controller.request.json = [
                occurrenceId: 'f6f8a9b8-4d52-49c3-9352-155f154fc96c',
                userId: userKeef.alaUserId,
                tags: 'octopus, orange',
                comment: 'whatever'
        ]
        controller.createQuestionFromBiocache()

        then:
        initialNumberOfQuestions == 3
        Question question = Question.findByOccurrenceId('f6f8a9b8-4d52-49c3-9352-155f154fc96c')
        question.tags.each {tag ->
            ['octopus', 'orange'].contains(tag)
        }
        question.comments[0].comment == 'whatever'
        Question.count == 4
    }

    void "test question search web services"() {
        given:
        elasticSearchService.refreshIndex()

        when:
        //Reset previous response
        controller.response.reset()
        // No tag and created after a valid given date
        controller.params.tags = ''
        controller.params.dateCreated = Calendar.getInstance().format(ISO_8601_DATE_FORMAT)
        controller.questionSearch()
        def response = controller.response.json

        then:
        response.success == false
        response.result.isEmpty()
        response.messages.size() == 1

        when:
        //Reset previous response
        controller.response.reset()
        // Valid tag and no given date
        controller.params.tags = 'kangaroo'
        controller.params.dateCreated = null
        controller.questionSearch()
        response = controller.response.json

        then:
        response.success == false
        response.result.isEmpty()
        response.messages.size() == 1

        when:
        //Reset previous response
        controller.response.reset()
        // Valid tag and wrong given date
        controller.params.tags = 'kangaroo'
        controller.params.dateCreated = Calendar.getInstance().format('dd/MM/yyyy')
        controller.questionSearch()
        response = controller.response.json

        then:
        response.success == false
        response.result.isEmpty()
        response.messages.size() == 1

        when:
        //Reset previous response
        controller.response.reset()
        // No vaalid tag and not valid given date
        controller.params.tags = ''
        controller.params.dateCreated = Calendar.getInstance().format('dd/MM/yyyy')
        controller.questionSearch()
        response = controller.response.json

        then:
        response.success == false
        response.result.isEmpty()
        response.messages.size() == 2

        when:
        //Reset previous response
        controller.response.reset()
        // Get questions by a valid tag and created after a valid given date
        controller.params.tags = 'kangaroo'
        controller.params.dateCreated = Calendar.getInstance().format(ISO_8601_DATE_FORMAT)
        controller.questionSearch()
        response = controller.response.json

        then:
        response.success == true
        response.result.size() == 2
        response.result.each {question ->
            ['f6f8a9b8-4d52-49c3-9352-155f154fc96c', 'b185ec97-7155-4207-b8c1-b0f64244f1a7'].contains(question.occurrenceId)
        }

        when:
        //Reset previous response
        controller.response.reset()
        // Question with comma separated tags including spaces and created after a valid given date
        controller.params.tags = 'kangaroo, grey'
        controller.params.dateCreated = Calendar.getInstance().format(ISO_8601_DATE_FORMAT)
        controller.questionSearch()
        response = controller.response.json

        then:
        response.success == true
        response.result.size() == 1
        response.result[0].occurrenceId == '181718e6-fd3b-4a1b-8b40-3f83fd2965e5'

        when:
        //Reset previous response
        controller.response.reset()
        // Question with too many tags and created after a valid given date
        controller.params.tags = 'kangaroo, grey, fighting'
        controller.params.dateCreated = Calendar.getInstance().format(ISO_8601_DATE_FORMAT)
        controller.questionSearch()
        response = controller.response.json

        then:
        response.success == true
        response.result.size() == 0

        when:
        //Reset previous response
        controller.response.reset()
        // Question with non existent tag and created after a valid given date
        controller.params.tags = 'fighting'
        controller.params.dateCreated = Calendar.getInstance().format(ISO_8601_DATE_FORMAT)
        controller.questionSearch()
        response = controller.response.json

        then:
        response.success == true
        response.result.size() == 0

        when:
        //Reset previous response
        controller.response.reset()
        // Question with valid tag with future date
        controller.params.tags = 'kangaroo, grey'
        controller.params.dateCreated = (new Date() + 1).format(ISO_8601_DATE_FORMAT)
        controller.questionSearch()
        response = controller.response.json

        then:
        response.success == true
        response.result.size() == 0
    }
}
