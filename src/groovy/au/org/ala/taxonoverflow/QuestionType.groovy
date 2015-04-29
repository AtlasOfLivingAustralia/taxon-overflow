package au.org.ala.taxonoverflow

public enum QuestionType {

    IDENTIFICATION('Identification', ['scientificName'], ['commonName', 'taxonConceptID', 'description']),
    GEOCODING_ISSUE('Geospatial Issue', ['decimalLatitude','decimalLongitude'],['description']),
    TEMPORAL_ISSUE('Temporal Issue', [], ['year', 'month', 'day']),
    HABITAT_ISSUE('Habitat Issue', [], [])

    private String label
    private String camelCaseName
    private List<String> requiredFields
    private List<String> optionalFields

    QuestionType(String label, List requiredFields, List optionalFields) {
        this.label = label
        this.camelCaseName = label.replaceAll("\\s","")
        this.requiredFields = requiredFields
        this.optionalFields = optionalFields
    }

    public String getLabel(){
        label
    }

    public String getCamelCaseName(){
        camelCaseName
    }

    public List<String> getRequiredFields(){
        requiredFields
    }

    public List<String> getOptionalFields(){
        optionalFields
    }
}
