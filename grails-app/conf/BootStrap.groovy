import au.org.ala.taxonoverflow.Source

class BootStrap {

    def elasticSearchService
    def customJSONMarshallers
    def grailsApplication

    def init = { servletContext ->
        // Reference the service to make sure it's loaded and initialised
        elasticSearchService.ping()
        customJSONMarshallers.register()

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

    def destroy = {
    }
}
