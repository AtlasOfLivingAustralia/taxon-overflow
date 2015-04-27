modules = {

    'taxonoverflow-view' {
        dependsOn 'viewer', 'flexisel', 'leaflet', 'ajaxanywhere', 'taxonoverflow-common'
        resource url: 'js/taxonoverflow-view.js'
    }

    'taxonoverflow-list' {
        dependsOn 'taxonoverflow-common', 'ajaxanywhere'
        resource url: 'js/taxonoverflow-list.js'
    }

    'taxonoverflow-common' {
        dependsOn 'jquery', 'jquery.cookie', 'bootbox'
        resource url:'js/taxonoverflow-common.js'  //this is temporary
        resource url:'css/taxonoverflow.css'
    }

    bootbox {
        dependsOn 'jquery'
        resource url: 'vendor/bootbox/bootbox.js'
    }

    flexisel {
        dependsOn 'jquery'
        resource url:'vendor/flexisel/jquery.flexisel.js'
        resource url:'vendor/flexisel/style.css'
    }

    'jquery.cookie' {
        dependsOn 'jquery'
        resource url: 'vendor/jquery.cookie/jquery.cookie.js'
    }

}
