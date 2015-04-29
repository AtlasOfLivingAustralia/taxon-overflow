package au.org.ala.taxonoverflow

import au.org.ala.taxonoverflow.marshal.*
import groovy.util.logging.Log4j

@Log4j
class CustomJSONMarshallers {

    BiocacheService biocacheService
    EcodataService ecodataService

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
                log.info("Registering custom JSON marshaller: ${c.name}")
                def marshaller = c.newInstance() as ICustomJSONMarshaller
                marshaller.setBiocacheService(biocacheService)
                marshaller.setEcodataService(ecodataService)
                marshaller.register()
            } catch (Exception ex) {
                log.error("Failed to register custom JSON marshaller ${c.name}: ${ex.message}")
                ex.printStackTrace()
            }
        }
    }
}

