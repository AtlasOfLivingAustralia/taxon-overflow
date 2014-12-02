package au.org.ala.taxonoverflow

class AnswerComment extends Comment {

    Answer answer

    static belongsTo = [answer: Answer]

    static constraints = {
        answer nullable: false
        user nullable: false
        comment nullable: false
    }

}

