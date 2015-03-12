class UrlMappings {

	static mappings = {

        "/$controller/$action?/$id?(.$format)?"{
            constraints {
            }
        }

        "/question/$id"(controller: "question", action: "view" )

        "/ws/questionType"(controller: "webService", action: "listQuestionTypes" )

        "/ws/question"(controller: "webService", action:"createQuestionFromExternal")


        "/ws/$action?/$id?(.$format)?"{
            controller = "webService"
            constraints {
            }
        }

        "/"( controller: "question", action: "list", view:"/index")
        "500"(view:'/error')
	}
}
