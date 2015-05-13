<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="to-admin"/>
    <title>Admin Dashboard - Reindex question</title>
</head>
<body class="content">
<content tag="menuItemId">re-index</content>
<h2 class="heading-medium">Rebuild Full-Text index</h2>
<p>Click the button bellow to initiate the process. It might take a while to complete it.</p>
<button type="button" class="btn btn-primary" id="btnReindexAll">Reindex all questions</button>
<br/>
<br/>
<div class="alert alert-success" role="alert" style="display: none;"></div>

</body>
<r:script>

    $(function() {

        $("#btnReindexAll").click(function(e) {
            e.preventDefault();
            bootbox.confirm("Are you sure you want to rebuild the index?", function(result){
            if (result) {
                $.ajax("${createLink(controller: 'admin', action: 'ajaxReindexAll')}").done(function(results) {
                      if (results.success) {
                          $(".alert-success").text(results.questionCount + " questions scheduled");
                          $(".alert-success").show();
                      }
                });
            }});
        });

    });

</r:script>
</html>

