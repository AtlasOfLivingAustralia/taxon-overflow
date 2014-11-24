package au.org.ala.taxonoverflow

class QuestionTag {

    Question question
    String tag

    static constraints = {
        question nullable: false
        tag nullable: false
    }

}
