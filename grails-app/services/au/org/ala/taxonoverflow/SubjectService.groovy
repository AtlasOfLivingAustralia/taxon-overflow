package au.org.ala.taxonoverflow

import grails.transaction.NotTransactional
import grails.transaction.Transactional

@Transactional
class SubjectService {

    @NotTransactional
    def boolean subjectExists(String occurrenceId) {
        def existing = Subject.findByOccurrenceId(occurrenceId)
        return existing != null
    }

}
