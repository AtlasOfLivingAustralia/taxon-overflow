package au.org.ala.taxonoverflow

class Comment {

    User user
    Date commentDate
    String comment
    int votes // comments can be up/down voted to indicate if they are considered to add value or not

    static constraints = {
        user nullable: false
        commentDate nullable: false
        comment nullable: false, blank: false
    }

    static mapping = {
        comment length: 2048
    }

}
