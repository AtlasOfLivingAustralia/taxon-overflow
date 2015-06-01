modules = {

    'taxonoverflow-view' {
        dependsOn 'image-viewer', 'ajaxanywhere', 'taxonoverflow-common', 'img-gallery'
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

    'jquery.cookie' {
        dependsOn 'jquery'
        resource url: 'vendor/jquery.cookie/jquery.cookie.js'
    }

    'octicons' {
        resource url: 'vendor/octicons/octicons.css'
    }

    'img-gallery' {
        dependsOn 'image-viewer'
        resource url: 'vendor/img-gallery/lib/slider-pro/css/slider-pro.css'
        resource url: 'vendor/img-gallery/css/img-gallery.css'

        resource url: 'vendor/img-gallery/lib/slider-pro/js/jquery.sliderPro.js'
    }

}
