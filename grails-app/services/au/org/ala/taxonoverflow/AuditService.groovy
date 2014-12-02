package au.org.ala.taxonoverflow

import grails.transaction.NotTransactional
import grails.transaction.Transactional
import org.codehaus.groovy.grails.web.servlet.mvc.GrailsWebRequest

@Transactional
class AuditService {

    def userService

    private static String SESSION_QUESTION_VIEWS_KEY = "taxon-overflow.question.views"

    /**
     * The way the view counter works is on a per HTTP session basis - only one view per session is counted.
     *
     * @param question
     * @return
     */
    def logQuestionView(Question question) {

        if (question) {
            def session = GrailsWebRequest.lookup().session
            Map sessionViewsMap = (session.getAttribute(SESSION_QUESTION_VIEWS_KEY) as Map) ?: [:]

            if (!sessionViewsMap.containsKey(question.id)) {
                def questionView = new QuestionView(question: question, user: userService.currentUser)
                questionView.save(failOnError: true, flush: true)

                sessionViewsMap[question.id] = true

                session.setAttribute(SESSION_QUESTION_VIEWS_KEY, sessionViewsMap)

                return questionView
            }
        }

        return null
    }

    @NotTransactional
    def getQuestionViewCount(Question question) {
        if (question) {
            return QuestionView.countByQuestion(question)
        }
        return -1
    }


}
