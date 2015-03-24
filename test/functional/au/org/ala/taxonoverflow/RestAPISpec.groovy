package au.org.ala.taxonoverflow

import grails.plugins.rest.client.RestBuilder
import grails.plugins.rest.client.RestResponse
import grails.test.spock.IntegrationSpec
import spock.lang.Shared

/**
 * Created by rui008 on 19/03/15.
 */
class RestAPISpec extends IntegrationSpec {

    static final ISO_8601_DATE_FORMAT = 'yyyy-MM-dd'

    @Shared
    def grailsApplication
    @Shared
    def sessionFactory
    @Shared
    User userMick, userKeef
    @Shared
    QuestionService questionService
    @Shared
    UserService userService
    @Shared
    ElasticSearchService elasticSearchService
    @Shared
    SourceService sourceService
    @Shared
    Question question1, question2, question3, question4

    static transactional = false

    def setup() {
        // Clean elasticsearch index
        elasticSearchService.reinitialiseIndex()

        // Initialize users
        userMick = userService.getUserFromUserId('11841')
        userKeef = userService.getUserFromUserId('11842')

        // Initialize the DB
        // 1st question
        question1 = questionService.createQuestionFromOccurrence(
                '181718e6-fd3b-4a1b-8b40-3f83fd2965e5',
                QuestionType.IDENTIFICATION,
                ['kangaroo', 'grey'],
                userMick,
                '1st question 1st comment'
        ).result
        // 2nd question
        question2 = questionService.createQuestionFromOccurrence(
                'b185ec97-7155-4207-b8c1-b0f64244f1a7',
                QuestionType.IDENTIFICATION,
                ['kangaroo', 'brown'],
                userKeef,
                '2nd question 1st comment'
        ).result
        // 3rd question
        question3 = questionService.createQuestionFromOccurrence(
                'c9e9589c-383e-4629-8f80-ea7588c4ccb2',
                QuestionType.IDENTIFICATION,
                ['parrot'],
                userMick,
                '3rd question 1st comment'
        ).result

        // Clean Hibernate session
        sessionFactory.currentSession.flush()
        sessionFactory.currentSession.clear()
        // Get elasticsearch index in sync before executing any test
        elasticSearchService.processIndexTaskQueue()
    }

    def cleanup() {
        (grailsApplication.getArtefacts("Domain") as List).each {
            it.newInstance().list()*.delete()
        }
        sessionFactory.currentSession.flush()
        sessionFactory.currentSession.clear()

        sourceService.init()
    }

    void "test DB has been initialized"() {
        when:
        List<Question> questionList = Question.findAll()

        then:
        questionList.size() == 3
    }

    void "test adding a new question from biocache occurrence"() {
        given:
        RestBuilder rest = new RestBuilder()

        when:
        RestResponse response = rest.post("http://localhost:8080/${grailsApplication.metadata.'app.name'}/ws/question") {
            json([
                    source      : 'biocache',
                    occurrenceId: 'f6f8a9b8-4d52-49c3-9352-155f154fc96c',
                    userId      : userKeef.alaUserId,
                    tags        : 'octopus, orange',
                    comment     : 'whatever'
            ])
        }
        question4 = Question.findByOccurrenceId('f6f8a9b8-4d52-49c3-9352-155f154fc96c')

        then:
        response.status == 200
        question4.tags.each { tag ->
            ['octopus', 'orange'].contains(tag)
        }
        question4.comments[0].comment == 'whatever'
        Question.count == 4
    }

    void "test question search web services"() {
        given:
        elasticSearchService.refreshIndex()
        RestBuilder rest = new RestBuilder()

        when:
        // Query for questions with no tag and a valid date
        RestResponse response = rest.get("http://localhost:8080/${grailsApplication.metadata.'app.name'}/ws/question/search?tags=&dateCreated=${new Date().format(ISO_8601_DATE_FORMAT)}")

        then:
        response.json.success == false
        response.json.result.isEmpty()
        response.json.messages.size() == 1

        when:
        // Query for questions with valid tag and a no date
        response = rest.get("http://localhost:8080/${grailsApplication.metadata.'app.name'}/ws/question/search?tags=kangaroo&dateCreated=")

        then:
        response.json.success == false
        response.json.result.isEmpty()
        response.json.messages.size() == 1

        when:
        // Query for questions with valid tag and an invalid date
        response = rest.get("http://localhost:8080/${grailsApplication.metadata.'app.name'}/ws/question/search?tags=kangaroo&dateCreated=${new Date().format('dd/MM/yyyy')}")

        then:
        response.json.success == false
        response.json.result.isEmpty()
        response.json.messages.size() == 1

        when:
        // Query for questions with no tag and an invalid date
        response = rest.get("http://localhost:8080/${grailsApplication.metadata.'app.name'}/ws/question/search?tags=&dateCreated=${new Date().format('dd/MM/yyyy')}")

        then:
        response.json.success == false
        response.json.result.isEmpty()
        response.json.messages.size() == 2

        when:
        // Query for questions with a valid tag and crated after a valid date
        response = rest.get("http://localhost:8080/${grailsApplication.metadata.'app.name'}/ws/question/search?tags=kangaroo&dateCreated=${(new Date() - 1).format(ISO_8601_DATE_FORMAT)}")

        then:
        response.json.success == true
        response.json.result.size() == 2
        response.json.result.each {question ->
            [question1.id, question2.id].contains(question.id)
        }

        when:
        // Query for questions with comma separated tags (and spaces) and crated after a valid date
        response = rest.get("http://localhost:8080/${grailsApplication.metadata.'app.name'}/ws/question/search?tags=kangaroo, grey&dateCreated=${new Date().format(ISO_8601_DATE_FORMAT)}")

        then:
        response.json.success == true
        response.json.result.size() == 1
        response.json.result[0].occurrenceId == question1.occurrenceId

        when:
        // Query for questions with too many tags restrictions and created after a valid given date
        response = rest.get("http://localhost:8080/${grailsApplication.metadata.'app.name'}/ws/question/search?tags=kangaroo, grey,fighting&dateCreated=${new Date().format(ISO_8601_DATE_FORMAT)}")

        then:
        response.json.success == true
        response.json.result.isEmpty()
        response.json.messages.size() == 0

        when:
        // Query for questions with non existent tag and created after a valid given date
        response = rest.get("http://localhost:8080/${grailsApplication.metadata.'app.name'}/ws/question/search?tags=fighting&dateCreated=${new Date().format(ISO_8601_DATE_FORMAT)}")

        then:
        response.json.success == true
        response.json.result.isEmpty()
        response.json.messages.size() == 0

        when:
        // Query for questions with valid tag with future date
        response = rest.get("http://localhost:8080/${grailsApplication.metadata.'app.name'}/ws/question/search?tags=fighting&dateCreated=${(new Date() + 1).format(ISO_8601_DATE_FORMAT)}")

        then:
        response.json.success == true
        response.json.result.isEmpty()
        response.json.messages.size() == 0

        when:
        // Adds a comment that was done 2 days after creation
        sessionFactory.currentSession.flush()
        sessionFactory.currentSession.clear()
        QuestionComment questionComment = new QuestionComment(comment: "3rd question 2nd comment", user: userKeef)
        question3.addToComments(questionComment)
        question3.save(flush: true)
        questionComment.setDateCreated(new Date() + 2)
        questionComment.save(flush: true)
        // Make sure index is up to date before performing the search
        elasticSearchService.processIndexTaskQueue()
        elasticSearchService.refreshIndex()
        Thread.sleep(2000)
        // Query for questions with valid tag with comments made after a valid date
        response = rest.get("http://localhost:8080/${grailsApplication.metadata.'app.name'}/ws/question/search?tags=parrot&comments=${(new Date() + 1).format(ISO_8601_DATE_FORMAT)}")

        then:
        response.json.success == true
        response.json.result.size() == 1
        response.json.result[0].id == question3.id

        when:
        // Query for questions with valid tag with comments made with a future invalid date
        response = rest.get("http://localhost:8080/${grailsApplication.metadata.'app.name'}/ws/question/search?tags=parrot&comments=${(new Date() + 3).format(ISO_8601_DATE_FORMAT)}")

        then:
        response.json.success == true
        response.json.result.size() == 0

        when:
        // Adds an identification
        sessionFactory.currentSession.flush()
        sessionFactory.currentSession.clear()
        Answer answer = new Answer(question: question1, user: userMick, scientificName: 'Kangaroo vulgaris', description: 'just another kangaroo')
        question1.addToAnswers(answer)
        question1.save(flush: true)
        answer.setDateCreated(new Date() + 3)
        answer.save(flush: true)
        // Make sure index is up to date before performing the search
        elasticSearchService.processIndexTaskQueue()
        elasticSearchService.refreshIndex()
        Thread.sleep(2000)
        // Query for questions with valid tag with an identification made after a valid date
        response = rest.get("http://localhost:8080/${grailsApplication.metadata.'app.name'}/ws/question/search?tags=kangaroo&identifications=${(new Date() + 3).format(ISO_8601_DATE_FORMAT)}")

        then:
        response.json.success == true
        response.json.result.size() == 1
        response.json.result[0].id == question1.id

        when:
        // Query for questions with valid tag with an identification made after a future invalid date
        response = rest.get("http://localhost:8080/${grailsApplication.metadata.'app.name'}/ws/question/search?tags=kangaroo&identifications=${(new Date() + 4).format(ISO_8601_DATE_FORMAT)}")

        then:
        response.json.success == true
        response.json.result.size() == 0

        when:
        // Adds a comment that was done 3 days after creation
        sessionFactory.currentSession.flush()
        sessionFactory.currentSession.clear()
        questionComment = new QuestionComment(comment: "2nd question 2nd comment", user: userMick)
        question2.addToComments(questionComment)
        question2.save(flush: true)
        questionComment.setDateCreated(new Date() + 3)
        questionComment.save(flush: true)
        // Make sure index is up to date before performing the search
        elasticSearchService.processIndexTaskQueue()
        elasticSearchService.refreshIndex()
        Thread.sleep(2000)
        // Query for questions with valid tag with any activity after a valid date
        response = rest.get("http://localhost:8080/${grailsApplication.metadata.'app.name'}/ws/question/search?tags=kangaroo&activity=${(new Date() + 2).format(ISO_8601_DATE_FORMAT)}")

        then:
        response.json.success == true
        response.json.result.size() == 2
        response.json.result.each {question ->
            [question1.id, question2.id].contains(question.id)
        }

        when:
        // Query for questions with valid tag with any activity after a a future invalid date
        response = rest.get("http://localhost:8080/${grailsApplication.metadata.'app.name'}/ws/question/search?tags=kangaroo&activity=${(new Date() + 4).format(ISO_8601_DATE_FORMAT)}")
        then:
        response.json.success == true
        response.json.result.size() == 0
    }

}
