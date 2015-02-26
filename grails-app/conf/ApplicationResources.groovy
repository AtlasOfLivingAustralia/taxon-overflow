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
        resource url:'flexisel/jquery.flexisel.js'
        resource url:'flexisel/style.css'
    }

    leaflet {
        dependsOn 'jquery'
        resource url: 'js/leaflet/leaflet.js'
        resource url: 'js/leaflet/leaflet.css'
    }

}
