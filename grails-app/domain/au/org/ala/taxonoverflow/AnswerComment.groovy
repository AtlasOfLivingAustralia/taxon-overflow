package au.org.ala.taxonoverflow

class AnswerComment extends Comment {

    static belongsTo = [answer: Answer]

    static constraints = {
        answer nullable: false
    }

    def afterUpdate() {
        IndexHelper.indexQuestion(this.answer.question.id)
    }

    def afterInsert() {
        IndexHelper.indexQuestion(this.answer.question.id)
    }

    def afterDelete() {
        IndexHelper.indexQuestion(this.answer.question.id)
    }

}

