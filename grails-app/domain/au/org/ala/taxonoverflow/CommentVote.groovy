package au.org.ala.taxonoverflow

class CommentVote extends Vote {

    Comment comment

    static constraints = {
        comment nullable: false
    }

}
