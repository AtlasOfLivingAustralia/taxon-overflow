package au.org.ala.taxonoverflow

class QuestionComment extends Comment {

    Question question

    static belongsTo = [question: Question]

    static constraints = {
        question nullable: false
    }

}
