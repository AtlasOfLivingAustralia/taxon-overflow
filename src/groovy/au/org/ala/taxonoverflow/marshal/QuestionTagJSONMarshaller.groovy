package au.org.ala.taxonoverflow.marshal

import au.org.ala.taxonoverflow.QuestionTag

class QuestionTagJSONMarshaller extends AbstractJSONMarshaller<QuestionTag> {

    @Override
    protected void marshalObject(QuestionTag obj, Map result) {
        result.questionId = obj.question.id
        result.tag = obj.tag
        result.dateCreated = formatDate(obj.dateCreated)
    }

    @Override
    protected Class<QuestionTag> getWrappedClass() {
        return QuestionTag
    }
}
