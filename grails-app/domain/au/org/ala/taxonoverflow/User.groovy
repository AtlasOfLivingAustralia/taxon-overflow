package au.org.ala.taxonoverflow

class User {

    String alaUserId

    static constraints = {
        alaUserId nullable: false
    }

    static mapping = {
        table 'taxonoverflow_user'
        version false
    }

}
