class UrlMappings {

	static mappings = {

        "/$controller/$action?/$id?(.$format)?"{
            constraints {
            }
        }

        "/question/$id"(controller: "question", action: "view" )


        "/ws/questionType"(controller: "webService", action: "listQuestionTypes" )
        
        "/ws/question/bulkLookup"(controller: "webService", action:"questionIdLookup")
        "/ws/question"(controller: "webService", action:"createQuestionFromExternal")
        "/ws/question/search"(controller: 'webService', action: 'questionSearch', method: 'GET')
        "/ws/question/follow/$questionId/$userId"(controller: "webService", action: 'follow', method: 'GET')
        "/ws/question/unfollow/$questionId/$userId"(controller: "webService", action: 'unfollow', method: 'GET')
        "/ws/question/following/status/$questionId/$userId"(controller: "webService", action: 'followingQuestionStatus', method: 'GET')
        
        "/ws/$action?/$id?(.$format)?"{
            controller = "webService"
            constraints {
            }
        }

        "/"( controller: "question", action: "list", view:"/index")
        "500"(view:'/error')
	}
}
