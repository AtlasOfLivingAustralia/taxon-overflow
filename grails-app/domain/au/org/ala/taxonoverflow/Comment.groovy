package au.org.ala.taxonoverflow

class Comment {

    User user
    Date dateCreated
    String comment

    static constraints = {
        user column: "taxonoverflow_user", nullable: false
        comment nullable: false, blank: false
        dateCreated nullable: true
    }

    static mapping = {
        comment length: 2048
    }

}
