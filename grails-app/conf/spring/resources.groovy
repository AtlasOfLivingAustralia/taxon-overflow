import au.org.ala.taxonoverflow.CustomJSONMarshallers

// Place your Spring DSL code here
beans = {

    customJSONMarshallers(CustomJSONMarshallers) {
        biocacheService = ref("biocacheService")
        ecodataService = ref("ecodataService")
    }
}
