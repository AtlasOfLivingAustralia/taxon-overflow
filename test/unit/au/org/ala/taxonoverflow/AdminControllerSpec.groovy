package au.org.ala.taxonoverflow

import grails.test.mixin.TestFor
import grails.test.mixin.TestMixin
import grails.test.mixin.support.GrailsUnitTestMixin
import spock.lang.Specification

/**
 * See the API for {@link grails.test.mixin.support.GrailsUnitTestMixin} for usage instructions
 */
@TestMixin(GrailsUnitTestMixin)
@TestFor(AdminController)
class AdminControllerSpec extends Specification {

    def setup() {
    }

    def cleanup() {
    }

    void "test delete existing question"() {
        given:
        def mockQuestionService = Mock(QuestionService)
        mockQuestionService.deleteQuestion(1) >> new ServiceResult<Question>(success: true, result: new Question(id: 1), messages: ["The question with id 1 has been scheduled for removal."])
        controller.questionService = mockQuestionService

        when:
        params.questionId = 1
        controller.doDeleteQuestion()

        then:
        response.redirectedUrl == '/admin/deleteQuestion'
        flash.success == ['The question with id 1 has been scheduled for removal.']
        flash.error == null
    }

    void "test delete non existing question"() {
        given:
        def mockQuestionService = Mock(QuestionService)
        mockQuestionService.deleteQuestion(0) >> new ServiceResult<Question>(success: false, messages: ['Question with id 0 was not found.'])
        controller.questionService = mockQuestionService

        when:
        params.questionId = 0
        controller.doDeleteQuestion()

        then:
        response.redirectedUrl == '/admin/deleteQuestion'
        flash.error == ['Question with id 0 was not found.']
        flash.success == null
    }
}
