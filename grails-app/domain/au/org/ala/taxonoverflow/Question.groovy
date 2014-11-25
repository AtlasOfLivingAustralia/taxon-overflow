package au.org.ala.taxonoverflow

class Question {

    User user
    QuestionType questionType
    String occurrenceId

    static constraints = {
        user nullable: false
        questionType nullable: false
        occurrenceId nullable: false
    }

}
