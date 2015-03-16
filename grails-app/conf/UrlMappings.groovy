class UrlMappings {

	static mappings = {

        "/$controller/$action?/$id?(.$format)?"{
            constraints {
            }
        }

        "/question/$id"(controller: "question", action: "view" )

        "/ws/question/bulkLookup"(controller: "webService", action:"questionIdLookup")

        "/ws/questionType"(controller: "webService", action: "listQuestionTypes" )

        "/ws/question"(controller: "webService", action:"createQuestionFromExternal")


        "/ws/$action?/$id?(.$format)?"{
            controller = "webService"
            constraints {
            }
        }

        "/ws/question/follow/$questionId/$userId"(controller: "webService", action: 'follow', method: 'GET')
        "/ws/question/unfollow/$questionId/$userId"(controller: "webService", action: 'unfollow', method: 'GET')
        "/ws/question/following/status/$questionId/$userId"(controller: "webService", action: 'followingQuestionStatus', method: 'GET')

        "/"( controller: "question", action: "list", view:"/index")
        "500"(view:'/error')
	}
}
