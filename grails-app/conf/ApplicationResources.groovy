modules = {

    'taxonoverflow-view' {
        dependsOn 'select2', 'image-viewer', 'ajaxanywhere', 'taxonoverflow-common', 'img-gallery'
        resource url: 'js/taxonoverflow-view.js'
    }

    'taxonoverflow-list' {
        dependsOn 'taxonoverflow-common', 'ajaxanywhere', 'img-gallery', 'jquery.resizeandcrop', 'jquery.livefilter'
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

    'jquery.livefilter' {
        dependsOn 'jquery'
        resource url: 'vendor/jquery.livefilter/jquery.liveFilter.js'
    }

    'select2' {
        dependsOn 'jquery'
        resource url: 'vendor/select2/css/select2.css'
        resource url: 'vendor/select2/css/select2-bootstrap.css'
        resource url: 'vendor/select2/js/select2.js'
    }

}
