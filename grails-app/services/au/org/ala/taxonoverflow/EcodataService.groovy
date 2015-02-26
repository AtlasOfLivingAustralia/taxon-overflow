package au.org.ala.taxonoverflow

import grails.transaction.Transactional
import org.codehaus.groovy.grails.web.json.JSONObject

@Transactional
class EcodataService extends AbstractWebService {

    def grailsApplication

    def serviceMethod() {}

    def getRecord(String id, boolean useApiKey = false) {
        def ct = new CodeTimer("Getting occurrence from ecodata")
        try {
            def source = Source.findByName("ecodata")
            def url = source.wsBaseUrl + "${id.encodeAsURL()}"
            def json = getJson(url)
            def record = [
                occurrenceId: id,
                scientificName: json.scientificName,
                commonName: json.commonName,
                recordedBy: json.userDisplayName,
                userId: json.userId,
                eventDate: json.eventDate,
                locality: json.locality,
                occurrenceRemarks: json.occurrenceRemarks,
                decimalLatitude: json.decimalLatitude,
                decimalLongitude: json.decimalLongitude,
                coordinateUncertaintyInMeters: json.coordinateUncertaintyInMeters,
                imageIds:[],
                imageUrls:[]
            ]
            if(json.multimedia){
                record.imageIds = json.multimedia.collect { it.imageId }
                record.imageUrls = json.multimedia.collect { it.identifier }
            }
            record
        } finally {
            ct.stop(true)
        }
    }
}
