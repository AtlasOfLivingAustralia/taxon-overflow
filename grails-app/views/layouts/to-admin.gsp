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
                <li><span class="font-xxsmall">Administration</span></li>
            </ul>
        </div>
    </div>


    <div class="row-fluid">
        <div class="col-md-3">
            <ul class="nav nav-pills nav-stacked">
                <li class="${pageProperty(name: 'page.menuItemId')?.toLowerCase() == 'dashboard' ? 'active' : ''}">
                    <a href="${createLink(controller: 'admin', action: 'dashboard')}">Dashboard</a>
                </li>
                <li class="${pageProperty(name: 'page.menuItemId')?.toLowerCase() == 'delete-question' ? 'active' : ''}">
                    <a href="${createLink(controller: 'admin', action: 'deleteQuestion')}">Delete question</a>
                </li>
                <li class="${pageProperty(name: 'page.menuItemId')?.toLowerCase() == 're-index' ? 'active' : ''}">
                    <a href="${createLink(controller: 'admin', action: 'indexAdmin')}">Reindex questions</a>
                </li>
                <li class="${pageProperty(name: 'page.menuItemId')?.toLowerCase() == 'question-biocache' ? 'active' : ''}">
                    <a href="${createLink(controller: 'admin', action: 'createQuestionFromBiocache')}">Create question from Biocache</a>
                </li>
                <li class="${pageProperty(name: 'page.menuItemId')?.toLowerCase() == 'question-ecodata' ? 'active' : ''}">
                    <a href="${createLink(controller: 'admin', action: 'createQuestionFromEcodata')}">Create question from Ecodata</a>
                </li>
                <li class="${pageProperty(name: 'page.menuItemId')?.toLowerCase() == 'import-ecodata' ? 'active' : ''}">
                    <a href="${createLink(controller: 'admin', action: 'importFromEcodata')}">Import all from Ecodata</a>
                </li>
                <li class="${pageProperty(name: 'page.menuItemId')?.toLowerCase() == 'preview-notifications' ? 'active' : ''}">
                    <a href="${createLink(controller: 'admin', action: 'previewNotifications')}">Preview Email Notifications</a>
                </li>
            </ul>
        </div>

        <div class="col-md-9">
            <g:layoutBody/>
        </div>
    </div>
    </body>
</g:applyLayout>