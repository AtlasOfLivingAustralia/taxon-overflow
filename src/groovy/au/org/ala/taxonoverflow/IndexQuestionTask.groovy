package au.org.ala.taxonoverflow

class IndexQuestionTask {

    def long questionId
    def IndexOperation indexOperation

    public IndexQuestionTask(long questionId, IndexOperation indexOperation) {
        this.questionId = questionId
        this.indexOperation = indexOperation
    }

}

enum IndexOperation {
    Insert, Update, Delete
}