package au.org.ala.taxonoverflow

import au.org.ala.taxonoverflow.marshal.*

class CustomJSONMarshallers {

    BiocacheService biocacheService

    public static List<Class> marshallers = [
        QuestionJSONMarshaller,
        UserJSONMarshaller,
        AnswerJSONMarshaller,
        AnswerCommentJSONMarshaller,
        AnswerVoteJSONMarshaller,
        QuestionCommentJSONMarshaller,
        QuestionTagJSONMarshaller,
        QuestionViewJSONMarshaller
    ]

    public void register() {

        marshallers.each { Class c ->
            try {
                println "Registering custom JSON marshaller: ${c.name}"
                def marshaller = c.newInstance() as ICustomJSONMarshaller
                marshaller.setBiocacheService(biocacheService)
                marshaller.register()
            } catch (Exception ex) {
                println "Failed to register custom JSON marshaller ${c.name}: ${ex.message}"
                ex.printStackTrace()
            }
        }
    }

}

