class UrlMappings {

	static mappings = {

        "/$controller/$action?/$id?(.$format)?"{
            constraints {
            }
        }

        "/ws/$action?/$id?(.$format)?"{
            controller = "webService"
            constraints {
            }
        }

        "/"( controller: "question", action: "list", view:"/index")
        "500"(view:'/error')
	}
}
