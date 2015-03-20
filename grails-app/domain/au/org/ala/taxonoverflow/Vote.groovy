package au.org.ala.taxonoverflow

class Vote {

    User user
    int voteValue // 1 or -1 would be typical values. 0 value votes should be deleted
    Date dateCreated
    Date dateUpdated

    static constraints = {
        user column: "taxonoverflow_user", nullable: false
        dateCreated nullable: true
        dateUpdated nullable: true
    }
}
