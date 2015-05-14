package au.org.ala.taxonoverflow

class QuestionView {

    User user
    Date dateCreated

    static belongsTo = [question: Question]

    static constraints = {
        user column: "taxonoverflow_user", nullable: false
    }

    def afterUpdate() {
        IndexHelper.indexQuestion(this.question.id)
    }

    def afterInsert() {
        IndexHelper.indexQuestion(this.question.id)
    }

    def afterDelete() {
        IndexHelper.indexQuestion(this.question.id)
    }

}
