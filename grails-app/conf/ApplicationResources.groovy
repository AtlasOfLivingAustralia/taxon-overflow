modules = {

    'taxonoverflow-view' {
        dependsOn 'viewer', 'flexisel', 'leaflet', 'ajaxanywhere', 'taxonoverflow-common'
        resource url: 'js/taxonoverflow-view.js'
    }

    'taxonoverflow-list' {
        dependsOn 'taxonoverflow-common', 'ajaxanywhere', 'img-gallery'
        resource url: 'js/taxonoverflow-list.js'
    }

    'taxonoverflow-common' {
        dependsOn 'ala','jquery', 'jquery.cookie', 'bootbox', 'marked', 'octicons'
        resource url:'js/taxonoverflow-common.js'
        resource url:'css/taxonoverflow.css'
    }

    marked {
        resource url: 'vendor/marked/marked.js'
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

    'octicons' {
        resource url: 'vendor/octicons/octicons.css'
    }

    'img-gallery' {
        resource url: 'vendor/img-gallery/css/elastislide.css'
        resource url: 'vendor/img-gallery/css/img-gallery.css'

        resource url: 'vendor/img-gallery/js/jquery.elastislide.js'
    }

}
