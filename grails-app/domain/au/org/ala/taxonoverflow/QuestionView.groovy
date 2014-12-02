package au.org.ala.taxonoverflow

class QuestionView {

    Question question
    User user
    Date dateCreated

    static belongsTo = [question: Question]

    static constraints = {
    }
}
