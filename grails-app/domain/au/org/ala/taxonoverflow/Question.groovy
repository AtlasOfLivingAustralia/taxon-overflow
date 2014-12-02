package au.org.ala.taxonoverflow

class Question {

    User user
    QuestionType questionType
    String occurrenceId

    static hasMany = [comments: QuestionComment, views: QuestionView]

    static constraints = {
        user nullable: false
        questionType nullable: false
        occurrenceId nullable: false
    }

    static mapping = {
        comments sort: 'dateCreated', order: 'asc'
        views sort:'dateCreated', order: 'asc'
    }

}
