package au.org.ala.taxonoverflow.services

import au.org.ala.taxonoverflow.Question
import au.org.ala.taxonoverflow.QuestionService
import au.org.ala.taxonoverflow.QuestionType
import au.org.ala.taxonoverflow.ServiceResult
import au.org.ala.taxonoverflow.User
import au.org.ala.taxonoverflow.UserService
import grails.test.spock.IntegrationSpec

class QuestionServiceIntegrationSpec extends IntegrationSpec {

    UserService userService
    QuestionService questionService

    def setup() {
    }

    def cleanup() {
    }

    void "test deleting a question from the DB"() {
        given:
        User someUser = userService.getUserFromUserId("11069")
        ServiceResult<Question> serviceResult = questionService.createQuestionFromOccurrence(
                "d6d7fee3-2e5e-4e23-a154-ad9171a15ad4",
                QuestionType.IDENTIFICATION,
                ["deleteMe"],
                someUser,
                null)

        when:
        def result = questionService.deleteQuestion(serviceResult.result.id)

        then:
        result.success == true

    }
}
