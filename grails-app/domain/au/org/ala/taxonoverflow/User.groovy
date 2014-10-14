package au.org.ala.taxonoverflow

class User {

    String alaUserId

    static constraints = {
        alaUserId nullable: false
    }

    static mapping = {
        table 'vp_user'
        version false
    }

}
