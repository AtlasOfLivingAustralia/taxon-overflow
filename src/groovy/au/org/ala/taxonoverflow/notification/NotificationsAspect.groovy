package au.org.ala.taxonoverflow.notification

import au.org.ala.taxonoverflow.Answer
import au.org.ala.taxonoverflow.AnswerComment
import au.org.ala.taxonoverflow.Comment
import au.org.ala.taxonoverflow.Question
import au.org.ala.taxonoverflow.QuestionComment
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
        if (actionedItem instanceof ServiceResult) {
            ServiceResult serviceResult = actionedItem instanceof ServiceResult ? actionedItem as ServiceResult : null
            if (serviceResult.result) {
                sendNewCommentNotification(serviceResult.result)
            }
        } else if (actionedItem instanceof Answer) {
            //TODO
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
            String emailSubject = "${question.comments.size() > 1 ? "RE: " : ""}(Question #${question.id}) - New${comment instanceof AnswerComment ? ' identification' : ''} comment posted"
            String htmlBody = pageRenderer.render template: '/notifications/newCommentNotification', model: [comment: comment, userDetails: userDetails]
            List bccEmailAddresses = addressees.collect { user ->
                authService.getUserForUserId(user.alaUserId).userName
            }
            // Send email
            sendEmail(bccEmailAddresses, userDetails, emailSubject, htmlBody)
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
                mailService.sendMail {
                    bcc bccEmailAddresses.toArray()
                    from "${userDetails.displayName}<no-reply@ala.org.au>"
                    subject emailSubject
                    html htmlBody
                }
                log.debug("A notification email has been sent to the following users:\n" +
                        "${bccEmailAddresses}")
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
