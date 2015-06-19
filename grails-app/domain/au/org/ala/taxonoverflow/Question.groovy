package au.org.ala.taxonoverflow

class Question {

    User user
    QuestionType questionType
    String occurrenceId
    String title
    Date dateCreated
    Source source

    static belongsTo = User

    static hasMany = [comments: QuestionComment, views: QuestionView, answers: Answer, tags: QuestionTag, followers: User]

    static constraints = {
        user column: "taxonoverflow_user", nullable: false
        questionType nullable: false
        occurrenceId nullable: false
        title nullable: true
        dateCreated nullable: true
        followers nullable: true
        answers nullable: true
        tags nullable: true
        views nullable: true
        comments nullable: true
    }

    static mapping = {
        comments sort: 'dateCreated', order: 'asc'
        views sort: 'dateCreated', order: 'asc'
        tags sort: 'tag', order:'asc'
        answers cascade: 'all-delete-orphan'
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
