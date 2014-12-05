package au.org.ala.taxonoverflow

class QuestionTag {

    Question question
    String tag

    static belongsTo = [question: Question]

    static constraints = {
        question nullable: false
        tag nullable: false
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
