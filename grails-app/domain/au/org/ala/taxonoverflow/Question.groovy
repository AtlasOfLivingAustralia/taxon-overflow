package au.org.ala.taxonoverflow

class Question {

    User user
    QuestionType questionType
    String occurrenceId
    Date dateCreated
    Source source

    static belongsTo = User

    static hasMany = [comments: QuestionComment, views: QuestionView, answers: Answer, tags: QuestionTag, followers: User]

    static constraints = {
        user column: "taxonoverflow_user", nullable: false
        questionType nullable: false
        occurrenceId nullable: false
        dateCreated nullable: true
        followers nullable: true
    }

    static mapping = {
        comments sort: 'dateCreated', order: 'asc'
        views sort: 'dateCreated', order: 'asc'
        tags sort: 'tag', order:'asc'
    }

    def afterUpdate() {
        IndexHelper.indexQuestion(this.id)
    }

    def afterInsert() {
        IndexHelper.indexQuestion(this.id)
    }

    def afterDelete() {
        IndexHelper.deleteQuestionFromIndex(this.id)
    }

}
