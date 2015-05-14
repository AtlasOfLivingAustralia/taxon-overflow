package au.org.ala.taxonoverflow

class QuestionTag {

    String tag
    Date dateCreated

    static belongsTo = [question: Question]

    static constraints = {
        question nullable: false
        tag nullable: false
        dateCreated nullable: true
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
