package au.org.ala.taxonoverflow

class User {

    String alaUserId
    Boolean enableNotifications = true
    SortedSet<String> tags // populated from elasticsearch TODO fix QuestionTags to be used here

    static hasMany = [followedQuestions: Question, tags: String]

    static constraints = {
        alaUserId nullable: false
        followedQuestions nullable: true
        enableNotifications nullable: true, defaultValue: true
    }

    static mapping = {
        table 'taxonoverflow_user'
        version false
    }

}
