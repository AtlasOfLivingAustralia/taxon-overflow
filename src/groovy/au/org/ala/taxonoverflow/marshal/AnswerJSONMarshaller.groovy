package au.org.ala.taxonoverflow.marshal

import au.org.ala.taxonoverflow.Answer

class AnswerJSONMarshaller extends AbstractJSONMarshaller<Answer> {

    @Override
    protected void registerImpl(Answer answer, Map result) {
        result.id = answer.id
        result.questionId = answer.question.id
        result.user = answer.user
        result.dateCreated = formatDate(answer.dateCreated)
        result.accepted = answer.accepted
        result.dateAccepted = formatDate(answer.dateAccepted)
        result.votes = answer.votes
        result.comments = answer.comments
        result.scientificName = answer.scientificName
        result.description = answer.description
    }

    @Override
    protected Class<Answer> getWrappedClass() {
        return Answer.class
    }
}
