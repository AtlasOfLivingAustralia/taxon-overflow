package au.org.ala.taxonoverflow

class Answer {

    Question question
    User user
    Date dateCreated
    boolean accepted
    Date dateAccepted

    static hasMany = [votes: AnswerVote]

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
