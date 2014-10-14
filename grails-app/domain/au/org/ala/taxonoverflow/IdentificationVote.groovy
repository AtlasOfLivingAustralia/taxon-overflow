package au.org.ala.taxonoverflow

class IdentificationVote extends Vote {

    Identification identification

    static constraints = {
        identification nullable: false
    }

}
