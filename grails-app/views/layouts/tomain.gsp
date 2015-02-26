<g:applyLayout name="main" >
    <head>
        <r:require module="application"/>
        <r:script disposition="head">
            var TAXON_OVERFLOW_CONF = {
                areYouSureUrl: "${createLink(controller:"dialog", action: "areYouSureFragment")}",
                pleaseWaitUrl: "${createLink(controller:'dialog', action:'pleaseWaitFragment')}"
            };

            var GSP_VARS = {
                leafletImagesDir: "${resource(dir:'/js/leaflet/images')}"
            };

        </r:script>
        <link href="//maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" rel="stylesheet">
    </head>

    <body>
        <div class="pull-right">
            <to:userContext />
            <auth:ifAnyGranted roles="${au.org.ala.web.CASRoles.ROLE_ADMIN}">
                <a href="${createLink(controller:'admin')}">Admin</a>
            </auth:ifAnyGranted>
        </div>
        <g:layoutBody/>
    </body>
</g:applyLayout>