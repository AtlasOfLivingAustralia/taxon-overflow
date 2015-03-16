package au.org.ala.taxonoverflow

class User {

    String alaUserId

    static hasMany = [followedQuestions: Question]

    static constraints = {
        alaUserId nullable: false
        followedQuestions nullable: true
    }

    static mapping = {
        table 'taxonoverflow_user'
        version false
    }

}
