package au.org.ala.taxonoverflow.marshal

import au.org.ala.taxonoverflow.Question

class QuestionJSONMarshaller extends AbstractJSONMarshaller<Question> {

    @Override
    protected void marshalObject(Question obj, Map result) {
        result.id = obj.id
        result.user = obj.user
        result.questionType = obj.questionType?.toString()
        result.occurrenceId = obj.occurrenceId
        result.source = obj.source.name
        result.comments = obj.comments
        result.answers = obj.answers
        result.tags = obj.tags
        result.views = obj.views
        result.dateCreated = formatDate(obj.dateCreated)

        result.viewCount = obj.views?.size() ?: 0
        result.answerCount = obj.answers?.size() ?: 0

        //FIXME
        if(obj.source.name == "biocache"){
            def occurrenceData = biocacheService.getRecord(obj.occurrenceId)
            result.occurrence = occurrenceData
        }
        if(obj.source.name == "ecodata"){
            def occurrenceData = ecodataService.getRecord(obj.occurrenceId)
            result.occurrence = occurrenceData
        }

    }

    @Override
    protected Class<Question> getWrappedClass() {
        return Question.class
    }

}
