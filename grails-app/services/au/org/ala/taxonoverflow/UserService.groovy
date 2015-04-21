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

    /**
     * Add/remove tags that user is following
     *
     * @param follow
     * @param tagId
     * @param alaUserId
     * @return
     */
    ServiceResult<User> followOrUnfollowTagByUser(boolean follow, String tag, String alaUserId) {
        if (!tag) {
            return new ServiceResult<User>().fail("Tag provided with value: ${tag} is invalid")
        }

        User user =  User.findByAlaUserId(alaUserId)
        if (!user) {
            return new ServiceResult<User>().fail("User provided with id: ${alaUserId} is invalid")
        }

        if (follow) {
            user.addToTags(tag)
            user.save(flush: true)
            return new ServiceResult<User>(success: true, messages: ["User with id: ${alaUserId} is now following tag with id: ${tag}"])
        } else {
            user.removeFromTags(tag)
            user.save(flush: true)
            return new ServiceResult<User>(success: true, messages: ["User with id: ${alaUserId} is now not following tag with id: ${tag}"])
        }
    }

    /**
     * Get list of tags for ALA userId
     *
     * @param alaUserId
     * @return
     */
    ServiceResult<User> getFollowedTagsForUserId(String alaUserId) {
        User user =  User.findByAlaUserId(alaUserId)
        if (!user) {
            return new ServiceResult<User>().fail("User provided with id: ${alaUserId} is invalid")
        }

        Set<String> tags = user.tags

        return new ServiceResult<LinkedHashMap>(result: tags, success: true, messages: ["User with id: ${alaUserId} is following ${tags.size()} tags"])
    }


}
