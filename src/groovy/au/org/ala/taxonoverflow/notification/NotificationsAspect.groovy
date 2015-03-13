package au.org.ala.taxonoverflow.notification

import au.org.ala.taxonoverflow.Answer
import au.org.ala.taxonoverflow.AnswerComment
import au.org.ala.taxonoverflow.Comment
import au.org.ala.taxonoverflow.Question
import au.org.ala.taxonoverflow.QuestionComment
import au.org.ala.taxonoverflow.QuestionTag
import au.org.ala.taxonoverflow.ServiceResult
import au.org.ala.taxonoverflow.User
import au.org.ala.web.AuthService
import au.org.ala.web.UserDetails
import grails.async.Promise
import grails.gsp.PageRenderer
import grails.plugin.mail.MailService
import groovy.util.logging.Log4j
import org.aspectj.lang.annotation.AfterReturning
import org.aspectj.lang.annotation.Aspect
import org.aspectj.lang.annotation.Pointcut
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Component

import static grails.async.Promises.task

@Aspect
@Component("refreshUserAspect")
@Log4j
class NotificationsAspect {

    def grailsApplication

    @Autowired
    MailService mailService

    @Autowired
    AuthService authService

    @Autowired
    PageRenderer pageRenderer

    @Pointcut("@annotation(au.org.ala.taxonoverflow.notification.SendEmailNotification)")
    public void enableEmailNotifications() {}

    @AfterReturning(pointcut = "au.org.ala.taxonoverflow.notification.NotificationsAspect.enableEmailNotifications()",
                    returning = "actionedItem")
    public void sendEmailNotification(def actionedItem) {
        ServiceResult serviceResult = actionedItem instanceof ServiceResult ? actionedItem as ServiceResult : null
        if (serviceResult.success && serviceResult.result instanceof Comment) {
            sendNewCommentNotification(serviceResult.result)
        } else if (serviceResult.success && serviceResult.result instanceof Answer) {
            sendAnswerNotification(serviceResult.result)
        } else if (serviceResult.success && serviceResult.result instanceof QuestionTag) {
            sendNewTagNotification(serviceResult.result)
        }
    }

    private sendNewTagNotification(QuestionTag questionTag) {
        Question question = questionTag.question
        log.debug("The tag \"${questionTag.tag}\" was added to question #${question.id}")

        HashSet<User> addressees = findAddressees(question, question.user)

        if (addressees.size() > 0) {
            // Compose email
            UserDetails userDetails = authService.getUserForUserId(question.user.alaUserId)
            String emailSubject = "(Question #${question.id}) - New tag added"
            String htmlBody = pageRenderer.render template: '/notifications/newTagNotification', model: [questionTag: questionTag]
            List bccEmailAddresses = addressees.collect { user ->
                authService.getUserForUserId(user.alaUserId).userName
            }
            // Send email
            if(grails)
            sendEmail(bccEmailAddresses, userDetails, emailSubject, htmlBody)
        }
    }

    private sendAnswerNotification(Answer answer) {
        Question question = answer.question
        User actionUser = answer.accepted ? question.user : answer.user
        log.debug("An identification answer has been ${answer.accepted ? 'accepted' : 'posted'} for question #${question.id} " +
                "by the user with id: ${actionUser.id}")

        // Find notification addresses
        HashSet<User> addressees = findAddressees(question, actionUser)

        if (addressees.size() > 0) {
            // Compose email
            UserDetails userDetails = authService.getUserForUserId(actionUser.alaUserId)
            if(userDetails){
                String emailSubject = "(Question #${question.id}) - Identification answer ${answer.accepted ? 'accepted' : 'posted'}"
                String htmlBody = pageRenderer.render template: '/notifications/answerNotification', model: [answer: answer, userDetails: userDetails]
                List bccEmailAddresses = addressees.collect { user ->
                    authService.getUserForUserId(user.alaUserId).userName
                }
                // Send email
                sendEmail(bccEmailAddresses, userDetails, emailSubject, htmlBody)
            } else {
                log.error("Unable to send notification for answer. User lookup failed. Check authorised system access.")
            }
        }
    }

    private sendNewCommentNotification(Comment comment) {
        Question question = comment instanceof AnswerComment ? (comment as AnswerComment).answer.question : (comment as QuestionComment).question
        log.debug("A new${comment instanceof AnswerComment ? ' identification' : ''} comment for question: ${question.id} has been posted by user with id: ${comment.userId}. Sending notification email...")

        // Find notification addresses
        HashSet<User> addressees = findAddressees(question, comment.user)

        if (addressees.size() > 0) {
            // Compose email
            UserDetails userDetails = authService.getUserForUserId(comment.user?.alaUserId)
            if(userDetails){
                String emailSubject = "${question.comments.size() > 1 ? "RE: " : ""}(Question #${question.id}) - New${comment instanceof AnswerComment ? ' identification' : ''} comment posted"
                String htmlBody = pageRenderer.render template: '/notifications/newCommentNotification', model: [comment: comment, userDetails: userDetails]
                List bccEmailAddresses = addressees.collect { user ->
                    authService.getUserForUserId(user.alaUserId).userName
                }
                // Send email
                sendEmail(bccEmailAddresses, userDetails, emailSubject, htmlBody)
            } else {
                log.error("Unable to send notification for comment. User lookup failed. Check authorised system access.")
            }
        }
    }

    /**
     * Sends email asynchronously
     * @param bccEmailAddresses
     * @param userDetails
     * @param emailSubject
     * @param htmlBody
     * @return
     */
    private Promise sendEmail(List bccEmailAddresses, userDetails, String emailSubject, String htmlBody) {
        return task {
            try {
                if(grailsApplication.config.notifications.enabled){
                    mailService.sendMail {
                        bcc bccEmailAddresses.toArray()
                        from "${userDetails.displayName}<no-reply@ala.org.au>"
                        subject emailSubject
                        html htmlBody
                    }
                    log.debug("A notification email has been sent to the following users:\n" +
                            "${bccEmailAddresses}")
                } else {
                    log.warn("Notifications disabled - A notification email has NOT been sent to the following users:\n" +
                            "${bccEmailAddresses}")
                }
            } catch (e) {
                log.error("There was a problem sending a notification email: ${e}")
            }
        }
    }

    private HashSet<User> findAddressees(Question question, User lastCommentUser) {
        // retrieve addressees
        Set<User> addressees = new HashSet<>()
        // Question creator
        addressees.add(question.user)
        // Question comments creators
        question.comments.each { previousComment ->
            addressees.add(previousComment.user)
        }
        // Remove last comment user
        addressees.remove(lastCommentUser)
        return addressees
    }
}
