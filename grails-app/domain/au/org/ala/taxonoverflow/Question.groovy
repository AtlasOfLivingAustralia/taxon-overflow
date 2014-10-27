package au.org.ala.taxonoverflow

class Question {

    QuestionType questionType
    String occurrenceId

    static constraints = {
        questionType nullable: false
        occurrenceId nullable: false
    }

}
