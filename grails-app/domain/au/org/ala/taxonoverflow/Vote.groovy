package au.org.ala.taxonoverflow

class Vote {

    User user
    VoteType voteType
    Date dateCreated
    Date dateUpdated

    static constraints = {
        user nullable: false
        voteType nullable: false
    }

}
