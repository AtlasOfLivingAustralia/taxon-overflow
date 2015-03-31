package au.org.ala.taxonoverflow

import grails.transaction.Transactional

@Transactional
class SourceService {

    def grailsApplication

    def init() {
        //add biocache instance
        def biocacheSource = Source.findByName("biocache")
        if(!biocacheSource){
            biocacheSource = new Source(name:"biocache", wsBaseUrl: grailsApplication.config.biocacheService.recordUrl, uiBaseUrl: grailsApplication.config.biocacheWebapp.recordUrl)
        } else {
            biocacheSource.wsBaseUrl = grailsApplication.config.biocacheService.recordUrl
            biocacheSource.uiBaseUrl = grailsApplication.config.biocacheWebapp.recordUrl
        }
        biocacheSource.save(flush:true)

        //add ecodata instance
        def ecodataSource = Source.findByName("ecodata")
        if(!ecodataSource){
            ecodataSource = new Source(name:"ecodata", uiBaseUrl: grailsApplication.config.pigeonhole.recordUrl, wsBaseUrl: grailsApplication.config.ecodata.recordUrl)
        } else {
            ecodataSource.wsBaseUrl = grailsApplication.config.ecodata.recordUrl
            ecodataSource.uiBaseUrl = grailsApplication.config.pigeonhole.recordUrl
        }
        ecodataSource.save(flush:true)
    }
}
