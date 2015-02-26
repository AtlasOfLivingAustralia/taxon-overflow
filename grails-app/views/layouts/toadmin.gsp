<g:applyLayout name="main" >
  <head>
    <r:require module="application"/>
    <r:script disposition="head">
            var TAXON_OVERFLOW_CONF = {
                areYouSureUrl: "${createLink(controller:"dialog", action: "areYouSureFragment")}",
                pleaseWaitUrl: "${createLink(controller:'dialog', action:'pleaseWaitFragment')}"
            };
    </r:script>
    <link href="//maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" rel="stylesheet">
  </head>

  <body>
    <div>
      <legend>
        <table style="width: 100%">
          <tr>
            <td><g:link uri="/">Home</g:link><to:navSeparator/><g:link controller="admin" action="index">Administration</g:link><to:navSeparator/><g:pageProperty name="page.pageTitle"/></td>
            <td style="text-align: right"><span><g:pageProperty name="page.adminButtonBar"/></span></td>
          </tr>
        </table>
      </legend>

      <div class="row-fluid">
        <div class="span3">
          <ul class="nav nav-list nav-stacked nav-tabs">
            <to:menuNavItem href="${createLink(controller: 'admin', action: 'dashboard')}" title="Dashboard" />
            <to:menuNavItem href="${createLink(controller: 'admin', action: 'indexAdmin')}" title="Full text index" />
          </ul>

        </div>
        <div class="span9">
          <g:layoutBody/>
        </div>
      </div>
    </div>
  </body>
</g:applyLayout>