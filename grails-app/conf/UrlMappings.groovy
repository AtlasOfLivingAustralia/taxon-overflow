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

        "/"(view:"/index")
        "500"(view:'/error')
	}

}
