package au.org.ala.taxonoverflow

import grails.transaction.NotTransactional
import grails.transaction.Transactional
import org.apache.commons.lang.StringUtils
import org.codehaus.groovy.grails.web.json.JSONObject

@Transactional
class QuestionService {

    def biocacheService

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

    def createQuestionFromOccurrence(String occurrenceId, QuestionType questionType, List<String> tags, User user) {

        def occurrence = biocacheService.getRecord(occurrenceId)

        if (occurrence && (occurrence.raw?.uuid || occurrence.processed?.uuid)) {

            // the id used to search for an occurrence may not be canonical, so
            // once we've found an occurrence, use the canonical id from then on...

            occurrenceId = occurrence.raw?.uuid ?: occurrence.processed?.uuid

            def errors = []
            if (validateOccurrenceRecord(occurrenceId, occurrence, errors)) {
                def question = new Question(user: user, occurrenceId: occurrenceId, questionType: questionType)
                question.save()

                // Save the tags
                tags?.each {
                    if (!StringUtils.isEmpty(it)) {
                        def tag = new QuestionTag(question: question, tag: it)
                        tag.save()
                    }
                }

                return question
            }

        }

        return null
    }

    public boolean validateOccurrenceRecord(String occurrenceId, JSONObject occurrence, List errors) {

        // first check if a question already exists for this occurrence

        if (questionExists(occurrenceId)) {
            errors << "A question already exists for this occurrence"
            return false
        }

        // TODO: Check that the occurrence record is sufficient to create a question (i.e. contains the minimum set of required fields)


        return true
    }


}
