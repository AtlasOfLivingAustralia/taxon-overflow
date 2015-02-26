package au.org.ala.taxonoverflow

class Question {

    User user
    QuestionType questionType
    String occurrenceId
    Date dateCreated
    Source source

    static hasMany = [comments: QuestionComment, views: QuestionView, answers: Answer, tags: QuestionTag]

    static constraints = {
        user nullable: false
        questionType nullable: false
        occurrenceId nullable: false
        dateCreated nullable: true
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
