package au.org.ala.taxonoverflow

class SubjectComment extends Comment {

    Subject subject

    static constraints = {
        subject nullable: false
    }

}
