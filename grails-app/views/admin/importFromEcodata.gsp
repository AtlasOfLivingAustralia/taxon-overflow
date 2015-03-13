<!DOCTYPE html>
<html>
<head>
  <meta name="layout" content="toadmin"/>
  <title>Admin Dashboard</title>
  <style type="text/css" media="screen">
  </style>
</head>
<body class="content">
<content tag="pageTitle">Import from Ecodata</content>
<content tag="adminButtonBar" />
<button type="button" class="btn" id="btnImportEcodata">Import from ecodata questions</button>
</body>
<r:script>

    $(document).ready(function(e) {

        $("#btnImportEcodata").click(function(e) {
          e.preventDefault();
          $.ajax("${createLink(controller:'webService', action:'bulkLoadFromEcodata')}").done(function(results) {
            if (results.success) {
                alert("" + results.loadedCount + " questions loaded from ecodata");
            }
          });
        });

    });

</r:script>
</html>

