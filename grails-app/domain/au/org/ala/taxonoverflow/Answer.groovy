package au.org.ala.taxonoverflow

class Answer {

    Question question
    User user
    Date dateCreated
    boolean accepted
    Date dateAccepted

    static belongsTo = [question: Question]

    static hasMany = [votes: AnswerVote, comments: AnswerComment]

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

    static mapping = {
        comments sort: 'dateCreated', order: 'asc'
    }

    def afterUpdate() {
        IndexHelper.indexQuestion(this.question.id)
    }

    def afterInsert() {
        IndexHelper.indexQuestion(this.question.id)
    }

    def afterDelete() {
        IndexHelper.indexQuestion(this.question.id)
    }

}

