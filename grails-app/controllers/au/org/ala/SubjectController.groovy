package au.org.ala

import au.org.ala.taxonoverflow.Subject

class SubjectController {

    def index() {
        redirect(action:'list')
    }

    def list() {
        params.max = params.max ?: 20
        def subjects = Subject.list(params)
        def totalCount = Subject.count()
        [subjects: subjects, totalCount: totalCount]
    }

    def delete(int id) {
        def subject = Subject.get(id)
        if (subject) {
            subject.delete()
        } else {
            flash.message = "Failed to delete subject id ${id}. Subject not found."
        }
        redirect(action:'list')
    }

}
