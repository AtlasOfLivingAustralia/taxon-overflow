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
}
