package au.org.ala.taxonoverflow.services

import au.org.ala.taxonoverflow.Answer
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
        Question question = Question.first()
        // For unknown reasons the answers are not loaded when executing the test, but the code works when deployed O_o
        // So I need to do this as a workaround for the test to actually work
        question.answers = [Answer.first()] as Set
        question.save()

        when:
        assert question.answers.size() == 1
        def result = questionService.deleteQuestion(question.id)

        then:
        result.success == true

    }
}
