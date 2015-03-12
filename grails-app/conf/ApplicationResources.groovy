modules = {

    core {
        dependsOn 'jquery'
//        resource url: 'js/html5.js', plugin: "ala-web-theme", wrapper: { s -> "<!--[if lt IE 9]>$s<![endif]-->" }, disposition: 'head'
    }

    application {
        dependsOn('jquery')
        resource url:'js/taxonoverflow.js'
        resource url:'css/taxonoverflow.css'
    }

    flexisel {
        dependsOn 'jquery'
        resource url:'vendor/flexisel/jquery.flexisel.js'
        resource url:'vendor/flexisel/style.css'
    }

}
