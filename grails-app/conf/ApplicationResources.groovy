modules = {

    taxonoverflow {
        dependsOn('jquery')
        resource url:'js/taxonoverflow.js'  //this is temporary
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

}
