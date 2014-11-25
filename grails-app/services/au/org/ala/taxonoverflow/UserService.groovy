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

}
