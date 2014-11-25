package au.org.ala.taxonoverflow

class AnswerComment extends Comment {

    Answer identification

    static constraints = {
        identification nullable: false
        user nullable: false
        comment nullable: false
    }

}

