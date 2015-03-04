package au.org.ala.taxonoverflow

public enum QuestionType {
    IDENTIFICATION('Identification'),
    GEOCODING_ISSUE('Geocoding Issue'),
    SUSPECTED_OUTLIER('Suspected Outlier'),
    TEMPORAL_ISSUE('Temporal Issue'),
    TAXONOMIC_ISSUE('Taxonomic Issue'),
    HABITAT_ISSUE('Habitat Issue')

    private String label

    QuestionType(String label) {
        this.label = label
    }
}
