modules = {

    'taxonoverflow-view' {
        dependsOn 'image-viewer', 'ajaxanywhere', 'taxonoverflow-common', 'img-gallery'
        resource url: 'js/taxonoverflow-view.js'
    }

    'taxonoverflow-list' {
        dependsOn 'taxonoverflow-common', 'ajaxanywhere', 'img-gallery', 'jquery.resizeandcrop'
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

    'jquery.resizeandcrop' {
        dependsOn 'jquery'
        resource url: 'vendor/jquery.resizeandcrop/jquery.resizeandcrop.css'
        resource url: 'vendor/jquery.resizeandcrop/jquery.resizeandcrop.js'
    }

}
