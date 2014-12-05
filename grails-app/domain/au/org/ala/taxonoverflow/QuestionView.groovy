package au.org.ala.taxonoverflow

class QuestionView {

    Question question
    User user
    Date dateCreated

    static belongsTo = [question: Question]

    static constraints = {
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
