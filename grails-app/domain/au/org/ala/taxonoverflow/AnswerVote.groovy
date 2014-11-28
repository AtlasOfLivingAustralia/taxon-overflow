package au.org.ala.taxonoverflow

class AnswerVote extends Vote {

    static belongsTo = [answer: Answer]

    static constraints = {
        answer nullable: false
    }

}
