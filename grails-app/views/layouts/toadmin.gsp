<g:applyLayout name="main">
    <head>
        <r:require modules="taxonoverflow-common"/>
    </head>

    <body>

    <div class="row-fluid">
        <div class="col-md-12">
            <ul class="breadcrumb">
                <li><a class="font-xxsmall" href="http://ala.org.au">Home</a></li>
                <li><a class="font-xxsmall" href="${g.createLink(controller:"question", action:"list")}">Community identification help</a></li>
                <li><a class="font-xxsmall" href="#">Administration</a></li>
                <li class="font-xxsmall active"><g:pageProperty name="page.adminButtonBar"/></li>
            </ul>
        </div>
    </div>


    <div class="row-fluid">
        <div class="col-md-3">
            <ul class="nav nav-list nav-stacked nav-tabs">
                <to:menuNavItem href="${createLink(controller: 'admin', action: 'dashboard')}" title="Dashboard"/>
                <to:menuNavItem href="${createLink(controller: 'admin', action: 'indexAdmin')}"
                                title="Full text index"/>
                <to:menuNavItem href="${createLink(controller: 'admin', action: 'createQuestionFromBiocache')}"
                                title="Create question from Biocache"/>
                <to:menuNavItem href="${createLink(controller: 'admin', action: 'createQuestionFromEcodata')}"
                                title="Create question from Ecodata"/>
                <to:menuNavItem href="${createLink(controller: 'admin', action: 'importFromEcodata')}"
                                title="Import all from Ecodata"/>
                <to:menuNavItem href="${createLink(controller: 'admin', action: 'previewNotifications')}"
                                title="Preview Email Notifications"/>
            </ul>
        </div>

        <div class="col-md-9">
            <g:layoutBody/>
        </div>
    </div>
    </body>
</g:applyLayout>