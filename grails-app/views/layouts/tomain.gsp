<g:applyLayout name="main" >
    <head>
        <r:require modules="core,taxonoverflow"/>
        <r:script disposition="head">
            var TAXON_OVERFLOW_CONF = {
                areYouSureUrl: "${createLink(controller:"dialog", action: "areYouSureFragment")}",
                pleaseWaitUrl: "${createLink(controller:'dialog', action:'pleaseWaitFragment')}"
            };

            var GSP_VARS = {
                leafletImagesDir: "${resource(dir:'/vendor/leaflet')}"
            };
        </r:script>
        <link href="//maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" rel="stylesheet">
    </head>
    <body>
        <g:layoutBody/>
    </body>
</g:applyLayout>