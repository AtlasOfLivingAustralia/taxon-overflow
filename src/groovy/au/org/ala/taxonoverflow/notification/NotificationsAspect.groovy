package au.org.ala.taxonoverflow.notification

import au.org.ala.taxonoverflow.*
import au.org.ala.web.AuthService
import au.org.ala.web.UserDetails
import grails.async.Promise
import grails.gsp.PageRenderer
import grails.plugin.mail.MailService
import groovy.util.logging.Log4j
import org.aspectj.lang.annotation.AfterReturning
import org.aspectj.lang.annotation.Aspect
import org.aspectj.lang.annotation.Pointcut
import org.codehaus.groovy.grails.commons.GrailsApplication
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Component

import static grails.async.Promises.task

@Aspect
@Component("notificationsAspect")
@Log4j
class NotificationsAspect {

    @Autowired
    GrailsApplication grailsApplication

    @Autowired
    MailService mailService

    @Autowired
    AuthService authService

    @Autowired
    PageRenderer pageRenderer

    @Pointcut("@annotation(au.org.ala.taxonoverflow.notification.SendEmailNotification)")
    public void enableEmailNotifications() {}

    @Pointcut("@annotation(au.org.ala.taxonoverflow.notification.FollowQuestionByUser)")
    public void enableFollowQuestionByUser() {}

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

    @AfterReturning(pointcut = "au.org.ala.taxonoverflow.notification.NotificationsAspect.enableFollowQuestionByUser()",
            returning = "actionedItem")
    public void followQuestion(def actionedItem) {
        ServiceResult serviceResult = actionedItem instanceof ServiceResult ? actionedItem as ServiceResult : null
        if (serviceResult.success && serviceResult.result instanceof Question) {
            Question question = serviceResult.result as Question
            addQuestionToUserFollowingList(question.user, question)
        } else if (serviceResult.success && serviceResult.result instanceof QuestionComment) {
            QuestionComment comment = serviceResult.result as QuestionComment
            addQuestionToUserFollowingList(comment.user, comment.question)
        } else if (serviceResult.success && serviceResult.result instanceof AnswerComment) {
            AnswerComment answerComment = serviceResult.result as AnswerComment
            addQuestionToUserFollowingList(answerComment.user, answerComment.answer.question)
        } else if (serviceResult.success && serviceResult.result instanceof Answer) {
            Answer answer = serviceResult.result as Answer
            addQuestionToUserFollowingList(answer.user, answer.question)
        }
    }

    public void addQuestionToUserFollowingList(User user, Question question) {
        log.debug("User is currently following questions: ${user.getFollowedQuestions()}")
        if (!user.getFollowedQuestions() || !user.getFollowedQuestions().collect { it.id }.contains(question.id)) {
            user.addToFollowedQuestions(question)
            user.save(flush: true)
        }
    }

    private sendNewTagNotification(QuestionTag questionTag) {
        Question question = questionTag.question
        log.debug("The tag \"${questionTag.tag}\" was added to question #${question.id}. " +
                "Checking if notification emails need to be sent...")

        HashSet<User> addressees = findAddressees(question, question.user)

        if (addressees.size() > 0) {
            // Compose email
            UserDetails userDetails = authService.getUserForUserId(question.user.alaUserId)
            String emailSubject = "(Question #${question.id}) - New tag added"
            String htmlBody = pageRenderer.render template: '/notifications/newTagNotification', model: [questionTag: questionTag]
            List bccEmailAddresses = addressees.findAll { it.enableNotifications }.collect { user ->
                authService.getUserForUserId(user.alaUserId).userName
            }
            // Send email
            sendEmail(bccEmailAddresses, userDetails, emailSubject, htmlBody)
        } else {
            log.debug("There is no need to send emails. No addressees found.")
        }
    }

    private sendAnswerNotification(Answer answer) {
        Question question = answer.question
        User actionUser = answer.user
        log.debug("An identification answer has been ${answer.accepted ? 'accepted' : 'posted'} for question #${question.id} " +
                "by the user with id: ${actionUser.id}. " +
                "Checking if notification emails need to be sent...")

        // Find notification addresses
        HashSet<User> addressees = findAddressees(question, actionUser)

        if (addressees.size() > 0) {
            // Compose email
            UserDetails userDetails = authService.getUserForUserId(actionUser.alaUserId)
            if (userDetails) {
                String emailSubject = "(Question #${question.id}) - Identification answer ${answer.accepted ? 'accepted' : 'posted'}"
                String htmlBody = pageRenderer.render template: '/notifications/answerNotification', model: [answer: answer, userDetails: userDetails]
                List bccEmailAddresses = addressees.findAll { it.enableNotifications }.collect { user ->
                    authService.getUserForUserId(user.alaUserId).userName
                }
                // Send email
                sendEmail(bccEmailAddresses, userDetails, emailSubject, htmlBody)
            } else {
                log.error("Unable to send notification for answer. User lookup failed. Check authorised system access.")
            }
        } else {
            log.debug("There is no need to send emails. No addressees found.")
        }
    }

    private sendNewCommentNotification(Comment comment) {
        Question question = comment instanceof AnswerComment ? (comment as AnswerComment).answer.question : (comment as QuestionComment).question
        log.debug("A new${comment instanceof AnswerComment ? ' identification' : ''} comment for question: ${question.id} has been posted by user with id: ${comment.userId}. " +
                "Checking if notification emails need to be sent...")

        // Find notification addresses
        HashSet<User> addressees = findAddressees(question, comment.user)

        if (addressees.size() > 0) {
            // Compose email
            UserDetails userDetails = authService.getUserForUserId(comment.user?.alaUserId)
            if (userDetails) {
                String emailSubject = "${question.comments.size() > 1 ? "RE: " : ""}(Question #${question.id}) - New${comment instanceof AnswerComment ? ' identification' : ''} comment posted"
                String htmlBody = pageRenderer.render template: '/notifications/newCommentNotification', model: [comment: comment, userDetails: userDetails]
                List bccEmailAddresses = addressees.findAll { it.enableNotifications }.collect { user ->
                    authService.getUserForUserId(user.alaUserId).userName
                }
                // Send email
                sendEmail(bccEmailAddresses, userDetails, emailSubject, htmlBody)
            } else {
                log.error("Unable to send notification for comment. User lookup failed. Check authorised system access.")
            }
        } else {
            log.debug("There is no need to send emails. No addressees found.")
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
                if (grailsApplication.config.notifications.enabled) {
                    mailService.sendMail {
                        bcc bccEmailAddresses.toArray()
                        from "${userDetails.displayName}<no-reply@ala.org.au>"
                        subject "${grailsApplication.config.grails.mail.subjectPrefix ? grailsApplication.config.grails.mail.subjectPrefix + ' - ': ''}${emailSubject}"
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
        // Add followers
        question.followers.each { follower ->
            addressees.add(follower)
        }
        // Remove last comment user
        addressees.remove(lastCommentUser)
        return addressees
    }
}
