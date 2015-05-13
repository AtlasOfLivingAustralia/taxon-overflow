<!DOCTYPE html>
<html>
<head>
  <meta name="layout" content="to-admin"/>
  <title>Admin Dashboard</title>
  <style type="text/css" media="screen">
  </style>
</head>
<body class="content">
<content tag="menuItemId">import-ecodata</content>

<h2 class="heading-medium">Import all questions from ecodata records)</h2>

<button type="button" class="btn btn-primary" id="btnImportEcodata">Import</button>
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

