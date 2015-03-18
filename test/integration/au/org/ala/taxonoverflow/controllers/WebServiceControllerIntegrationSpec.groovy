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

    @Shared User userMick
    @Shared User userKeef
    @Shared WebServiceController controller = new WebServiceController()
    @Shared QuestionService questionService
    @Shared UserService userService
    @Shared ElasticSearchService elasticSearchService

    def setupSpec() {
        // Clean elasticsearch index
        elasticSearchService.reinitialiseIndex()

        // Initialize users
        userMick = userService.getUserFromUserId('11841')
        userKeef = userService.getUserFromUserId('11842')

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
    }

    def cleanupSpec() {

    }

    void "test DB has been initialized"() {
        when:
        List<Question> questionList = Question.findAll()

        then:
        questionList.size() > 0
    }

    void "test adding a new question from biocache occurrence"() {
        given:
        Integer numberOfQuestions = Question.count

        when:
        controller.request.json = [
                occurrenceId: 'f6f8a9b8-4d52-49c3-9352-155f154fc96c',
                userId: userKeef.alaUserId,
                tags: 'octopus, orange',
                comment: 'whatever'
        ]
        controller.createQuestionFromBiocache()

        then:
        Question question = Question.findByOccurrenceId('f6f8a9b8-4d52-49c3-9352-155f154fc96c')
        question.tags.each {tag ->
            ['octopus', 'orange'].contains(tag)
        }
        question.comments[0].comment == 'whatever'
    }
}
