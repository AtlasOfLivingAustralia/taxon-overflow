package au.org.ala.taxonoverflow.marshal

import au.org.ala.taxonoverflow.AnswerComment

class AnswerCommentJSONMarshaller extends AbstractJSONMarshaller<AnswerComment> {

    @Override
    protected void registerImpl(AnswerComment obj, Map result) {
        result.answerId = obj.answerId
        result.user = obj.user
        result.comment = obj.comment
        result.dateCreated = formatDate(obj.dateCreated)
    }

    @Override
    protected Class<AnswerComment> getWrappedClass() {
        return AnswerComment.class
    }

}
