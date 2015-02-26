package au.org.ala.taxonoverflow

import org.codehaus.groovy.grails.web.json.JSONObject

class BiocacheService extends AbstractWebService {

    def grailsApplication

    def getRecord(String id, boolean useApiKey = false) {
        def ct = new CodeTimer("Getting occurrence from biocache")
        try {
            def source = Source.findByName("biocache")
            def url = source.wsBaseUrl + "${id.encodeAsURL()}"
            if (useApiKey) {
                url += "?apiKey=${grailsApplication.config.biocache.apiKey ?: ''}"
            }
            def json = getJson(url)

            def record = [
                    occurrenceId: id,
                    scientificName: json.processed.classification.scientificName ?: json.raw.classification.scientificName,
                    commonName: json.processed.classification.vernacularName ?: json.raw.classification.vernacularName,
                    recordedBy: json.raw.occurrence.recordedBy,
                    userId: json.raw.occurrence.userId,
                    eventDate: json.processed.event.eventDate,
                    locality: json.raw.location.locality,
                    decimalLatitude: json.processed.location.decimalLatitude,
                    decimalLongitude: json.processed.location.decimalLongitude,
                    coordinateUncertaintyInMeters: json.processed.location.coordinateUncertaintyInMeters,
                    occurrenceRemarks: json.raw.occurrence.occurrenceRemarks,
                    locationRemarks: json.raw.location.locationRemarks,
                    imageIds:[],
                    imageUrls:[]
            ]
            if(json.images){
                record.imageIds = json.images.collect { it.filePath }
                record.imageUrls = json.images.collect { it.alternativeFormats.smallImageUrl }
            }
            record
        } finally {
            ct.stop(true)
        }
    }
}
