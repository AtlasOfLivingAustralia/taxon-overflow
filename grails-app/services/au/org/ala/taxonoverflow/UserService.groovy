package au.org.ala.taxonoverflow

import grails.transaction.Transactional

@Transactional
class UserService {

    def authService

    def getCurrentUser() {
        def userId = authService.userId
        return getUserFromUserId(userId)
    }

    def getUserFromUserId(String userId) {
        if (userId) {
            def user = User.findByAlaUserId(userId)

            if (!user) {
                user = new User(alaUserId: userId)
                user.save(flush: true, failOnError: true)
            }

            return user
        }
    }

    /**
     *
     * @param alaUserId
     * @param enableNotifications
     * @return
     */
    ServiceResult<User> switchUserNotifications(String alaUserId, boolean enableNotifications) {
        ServiceResult<User> result = new ServiceResult<>()
        User user = User.findByAlaUserId(alaUserId)
        if (!user) {
            result.fail("No valid ala user id provided: ${alaUserId}")
        } else {
            user.enableNotifications = enableNotifications
            user.save()
            result.success(user, ["The notifications for user with alaUserId = ${alaUserId} has been ${enableNotifications? 'enabled' : 'disabled'}"])
        }

        return result
    }

}
