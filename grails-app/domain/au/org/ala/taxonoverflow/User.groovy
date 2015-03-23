package au.org.ala.taxonoverflow

class User {

    String alaUserId
    Boolean enableNotifications = true

    static hasMany = [followedQuestions: Question]

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
