package au.org.ala.taxonoverflow.marshal

import au.org.ala.taxonoverflow.QuestionView

class QuestionViewJSONMarshaller extends AbstractJSONMarshaller<QuestionView> {

    @Override
    protected void marshalObject(QuestionView obj, Map result) {
        result.user = obj.user
        result.questionId = obj.question.id
        result.dateCreated = formatDate(obj.dateCreated)
    }

    @Override
    protected Class<QuestionView> getWrappedClass() {
        return QuestionView
    }
}
