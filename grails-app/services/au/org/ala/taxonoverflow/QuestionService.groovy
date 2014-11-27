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

    def createQuestionFromOccurrence(String occurrenceId, QuestionType questionType, List<String> tags, User user, List messages) {

        def occurrence = biocacheService.getRecord(occurrenceId)

        if (occurrence && (occurrence.raw?.uuid || occurrence.processed?.uuid)) {

            // the id used to search for an occurrence may not be canonical, so
            // once we've found an occurrence, use the canonical id from then on...

            occurrenceId = occurrence.raw?.uuid ?: occurrence.processed?.uuid

            if (validateOccurrenceRecord(occurrenceId, occurrence, messages)) {
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
            } else {

            }

        } else {
            messages << "Unable to retrieve occurrence details for ${occurrenceId}"
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

    def deleteAnswer(Answer answer) {
        answer?.delete(flush: true)
    }

    def acceptAnswer(Answer answer) {

        if (!answer) {
            return
        }

        // first check if there any other accepted answers for this question, and if there are, reset them (only one accepted answer at this point)
        def existing = Answer.findAllByQuestionAndAccepted(answer.question, true)
        existing.each { acceptedAnswer ->
            acceptedAnswer.accepted = false
            acceptedAnswer.dateAccepted = new Date()
            acceptedAnswer.save(failOnError: true)
        }

        answer.accepted = true
        answer.save()
    }

    def unacceptAnswer(Answer answer) {

        if (!answer) {
            return
        }

        if (answer.accepted) {
            answer.accepted = false
            answer.dateAccepted = null
            answer.save(failOnError: true)
        }

    }

    def castVoteOnAnswer(Answer answer, User user, VoteType voteType) {

        if (!answer || !user) {
            return
        }

        def vote = AnswerVote.findByAnswerAndUser(answer, user)

        if (voteType == VoteType.Retract) {
            if (vote) {
                vote.delete()
            }
        } else {
            if (!vote) {
                vote = new AnswerVote(user: user, answer: answer)
            }
            vote.voteValue = voteType == VoteType.Up ? 1 : -1
            vote.save(failOnError: true)
        }
    }

    def canUserAcceptAnswer(Answer answer, User user) {
        // If the current user is one who asked the question, they can accept the answer
        if (answer.question.user == user) {
            return true
        }

        return false
    }

}
