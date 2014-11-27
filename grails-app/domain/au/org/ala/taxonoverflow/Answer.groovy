package au.org.ala.taxonoverflow

class Answer {

    Question question
    User user
    Date dateCreated
    int votes
    boolean accepted
    Date dateAccepted

    // Below is superset of allowable answer fields, depending on question type
    String scientificName
    String description // Descriptive/free text for an answer

    static constraints = {
        question nullable: false
        user nullable: false
        description nullable: true
        scientificName nullable: true
        dateAccepted nullable: true
    }

}
