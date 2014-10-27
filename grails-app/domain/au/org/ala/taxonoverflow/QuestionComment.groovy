package au.org.ala.taxonoverflow

class QuestionComment extends Comment {

    Question question

    static constraints = {
        question nullable: false
    }

}
