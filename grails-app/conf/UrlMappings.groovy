class UrlMappings {

	static mappings = {

        "/ping"(controller: 'common', action: 'ping')

        "/admin"(controller: "admin", action:"index")

        "/question/$id"(controller: "question", action: "view" ) {
            constraints {
                id(matches:/\d+/)
            }
        }

        "/ws/questionType"(controller: "webService", action: "listQuestionTypes" )
        
        "/ws/question/bulkLookup"(controller: "webService", action:"questionIdLookup")
        "/ws/question"(controller: "webService", action:"createQuestionFromExternal")
        "/ws/question/search"(controller: 'webService', action: 'questionSearch', method: 'GET')
        "/ws/question/follow/$questionId/$userId"(controller: "webService", action: 'follow', method: 'GET')
        "/ws/question/unfollow/$questionId/$userId"(controller: "webService", action: 'unfollow', method: 'GET')
        "/ws/question/following/status/$questionId/$userId"(controller: "webService", action: 'followingQuestionStatus', method: 'GET')

        "/ws/tag/follow/$tag/$userId?"(controller: "webService", action: 'followTag', method: 'GET')
        "/ws/tag/unfollow/$tag/$userId?"(controller: "webService", action: 'unfollowTag', method: 'GET')
        "/ws/tag/following/$userId?"(controller: "webService", action: 'getFollowedTagsForUserId', method: 'GET')


        "/ws/user/notifications/enable"(controller: 'webService', action: 'switchUserNotifications', method: 'GET') {
            enable = true
        }
        "/ws/user/notifications/disable"(controller: 'webService', action: 'switchUserNotifications', method: 'GET') {
            enable = false
        }

        "/ws/$action?/$id?(.$format)?"{
            controller = "webService"
            constraints {
            }
        }

        "/$controller/$action?/$id?(.$format)?"{
            constraints {
            }
        }

        "/"( controller: "question", action: "list")
        "500"(view:'/error')
	}
}
