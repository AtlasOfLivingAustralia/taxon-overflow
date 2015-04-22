<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="toadmin"/>
    <title>Admin Dashboard</title>
    <style type="text/css" media="screen">
    </style>
</head>

<body class="content">
<content tag="pageTitle">Reindex</content>
<content tag="adminButtonBar"/>
<button type="button" class="btn" id="btnReindexAll">Reindex all questions</button>
</body>
<r:script>

    $(document).ready(function(e) {

        $("#btnReindexAll").click(function(e) {
          e.preventDefault();
          $.ajax("${createLink(controller: 'admin', action: 'ajaxReindexAll')}").done(function(results) {
            if (results.success) {
                alert("" + results.questionCount + " questions scheduled");
            }
          });
        });

    });

</r:script>
</html>

