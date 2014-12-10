package au.org.ala.taxonoverflow.marshal

import au.org.ala.taxonoverflow.Question

class QuestionJSONMarshaller extends AbstractJSONMarshaller<Question> {

    @Override
    protected void marshalObject(Question obj, Map result) {
        result.id = obj.id
        result.user = obj.user
        result.questionType = obj.questionType?.toString()
        result.occurrenceId = obj.occurrenceId
        result.comments = obj.comments
        result.answers = obj.answers
        result.tags = obj.tags
        result.views = obj.views
        result.dateCreated = obj.dateCreated
    }

    @Override
    protected Class<Question> getWrappedClass() {
        return Question.class
    }

}
