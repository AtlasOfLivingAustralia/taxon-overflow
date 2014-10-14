package au.org.ala.taxonoverflow

class IdentificationComment extends Comment {

    Identification identification

    static constraints = {
        identification nullable: false
    }

}

