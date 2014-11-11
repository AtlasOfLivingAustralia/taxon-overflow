modules = {

    core {
        dependsOn 'jquery'
        resource url: 'js/html5.js', plugin: "ala-web-theme", wrapper: { s -> "<!--[if lt IE 9]>$s<![endif]-->" }, disposition: 'head'
    }

    bootstrap {
        dependsOn 'core'
        resource url:'js/bootstrap.js', plugin: 'ala-web-theme', disposition: 'head'
        resource url:'css/bootstrap.css', plugin: 'ala-web-theme', attrs:[media:'screen, projection, print']
        resource url:'css/bootstrap-responsive.css', plugin: 'ala-web-theme', attrs:[media:'screen', id:'responsiveCss']
    }

    application {
        dependsOn('jquery')
        resource url:'js/taxonoverflow.js'
    }

    flexisel {
        dependsOn 'jquery'
        resource url:'flexisel/jquery.flexisel.js'
        resource url:'flexisel/style.css'
    }

}
