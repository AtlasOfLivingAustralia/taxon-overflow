package au.org.ala.taxonoverflow

class QuestionComment extends Comment {

    Question question

    static belongsTo = [question: Question]

    static constraints = {
        question nullable: false
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
