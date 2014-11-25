<g:applyLayout name="main" >
    <head>
        <style type="text/css">
        </style>
        <r:script disposition="head">
            var TAXON_OVERFLOW_CONF = {
                areYouSureUrl: "${createLink(controller:"dialog", action: "areYouSureFragment")}",
                pleaseWaitUrl: "${createLink(controller:'dialog', action:'pleaseWaitFragment')}"
            };
        </r:script>
    </head>

    <body>
        <div class="row-fluid">
            <div class="span12">
                <to:userContext />
            </div>
        </div>
        <g:layoutBody/>
    </body>
</g:applyLayout>