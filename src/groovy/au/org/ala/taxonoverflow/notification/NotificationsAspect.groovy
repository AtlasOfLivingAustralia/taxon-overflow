package au.org.ala.taxonoverflow.notification

import au.org.ala.taxonoverflow.AnswerComment
import au.org.ala.taxonoverflow.Question
import au.org.ala.taxonoverflow.QuestionComment
import au.org.ala.taxonoverflow.ServiceResult
import au.org.ala.taxonoverflow.User
import au.org.ala.web.AuthService
import au.org.ala.web.UserDetails
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
        ServiceResult serviceResult = actionedItem instanceof ServiceResult ? actionedItem as ServiceResult : null

        if (serviceResult.result instanceof QuestionComment) {
            sendNewQuestionCommentNotification(serviceResult.result as QuestionComment)
        } else if (serviceResult.result instanceof AnswerComment) {

        }
    }

    private sendNewQuestionCommentNotification(QuestionComment comment) {
        Question question = comment.question
        log.debug("A new comment for question: ${question.id} has been posted by user with id: ${comment.userId}. Sending notification email...")

        HashSet<User> addressees = findAddressees(question, comment.user)

        if (addressees.size() > 0) {
            // Compose email
            UserDetails userDetails = authService.getUserForUserId(comment.user?.alaUserId)
            String emailSubject = "${question.comments.size() > 1 ? "RE: " : ""}(Question #${question.id}) - New comment posted"
            String htmlBody = pageRenderer.render template: '/notifications/newQuestionCommentNotification', model: [comment: comment, userDetails: userDetails]
            List bccEmailAddresses = addressees.collect { user ->
                authService.getUserForUserId(user.alaUserId).userName
            }
            // Send email asynchronously
            task {
                try {
                    mailService.sendMail {
                        bcc bccEmailAddresses.toArray()
                        from "${userDetails.displayName}<no-reply@ala.org.au>"
                        subject emailSubject
                        html htmlBody
                    }
                    log.debug("A notification email with comment for question: ${question.id} by user with id: ${comment.userId} has been sent to the following users:\n" +
                            "${bccEmailAddresses}")
                } catch (e) {
                    log.error("There was a problem sending a notification email: ${e}")
                }
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
