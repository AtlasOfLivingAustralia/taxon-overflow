package au.org.ala.taxonoverflow

class AnswerVote extends Vote {

    Answer answer

    static constraints = {
        answer nullable: false
    }

}
