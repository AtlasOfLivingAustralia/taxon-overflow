package au.org.ala.taxonoverflow

import au.org.ala.web.UserDetails
import grails.transaction.Transactional
import groovy.json.JsonSlurper

@Transactional
class EcodataService extends AbstractWebService {

    def grailsApplication

    def serviceMethod() {}

    /**
     * Retrieve details of this record
     *
     * @param id
     * @param useApiKey
     * @return
     */
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

    /**
     * Send an update to the source system.
     *
     * @param occurrenceId
     * @param json
     * @return
     */
    def updateRecord(occurrenceId, json, identifiedBy, dateIdentified){
        log.debug("Updating occurrence record at source ecodata: " + occurrenceId)
        def source = Source.findByName("ecodata")
        def url = source.wsBaseUrl + "${occurrenceId.encodeAsURL()}"
        def map = new JsonSlurper().parseText(json)
        map.put("lastUpdatedFromTaxonoverflow", new Date())
        map.put("identifiedBy", identifiedBy.displayName)
        map.put("identifiedByUserId", identifiedBy.userId)
        map.put("dateIdentified", dateIdentified.format("yyyy-MM-dd'T'HH:mm:ssZ"))
        doPost(url, map)
    }
}
