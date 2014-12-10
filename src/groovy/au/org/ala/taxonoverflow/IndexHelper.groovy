package au.org.ala.taxonoverflow

public class IndexHelper {

    public static void indexQuestion(long questionId) {
        ElasticSearchService.scheduleQuestionIndexation(questionId)
    }

    public static void deleteQuestionFromIndex(long questionId) {
        ElasticSearchService.scheduleQuestionDeletion(questionId)
    }

}
