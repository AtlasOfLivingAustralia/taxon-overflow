package au.org.ala.taxonoverflow.marshal

import au.org.ala.taxonoverflow.QuestionComment

class QuestionCommentJSONMarshaller extends AbstractJSONMarshaller<QuestionComment> {

    @Override
    protected void marshalObject(QuestionComment obj, Map result) {
        result.user = obj.user
        result.comment = obj.comment
        result.dateCreated = formatDate(obj.dateCreated)
        result.questionId = obj.question.id
    }

    @Override
    protected Class<QuestionComment> getWrappedClass() {
        return QuestionComment
    }
}
