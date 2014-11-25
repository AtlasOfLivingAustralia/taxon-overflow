package au.org.ala.taxonoverflow

class AnswerVote extends Vote {

    Answer identification

    static constraints = {
        identification nullable: false
        user nullable: false
    }

}
