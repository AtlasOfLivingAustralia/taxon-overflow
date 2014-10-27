package au.org.ala.taxonoverflow

import grails.transaction.NotTransactional
import grails.transaction.Transactional

@Transactional
class QuestionService {

    @NotTransactional
    def boolean questionExists(String occurrenceId) {
        def existing = Question.findByOccurrenceId(occurrenceId)
        return existing != null
    }

    def deleteQuestion(Question question) {
        if (question) {
            question.delete()
        }
    }

}
