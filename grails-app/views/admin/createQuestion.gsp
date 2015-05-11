<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="toadmin"/>
    <title>Create question | Atlas of Living Australia</title>
</head>

<body class="content">
<content tag="menuItemId">question-${source}</content>

<h2 class="heading-medium">Debug create ${source} question form (not intended for public use)</h2>

<div class="alert alert-error" style="display: none" id="errorMessageDiv"></div>

<form class="col-md-9">

    <div class="form-group">
        <label class="control-label">Occurrence Id</label>
        <g:textField name="occurrenceId" class="form-control"/>
    </div>

    <div class="form-group">
        <label class="control-label">Question type</label>
        <g:select name="questionType" class="form-control" from="${au.org.ala.taxonoverflow.QuestionType.values()}" optionValue="label"/>
    </div>

    <div class="form-group">
        <label class="control-label">Tags (comma separated)</label>
        <g:textField name="tags" class="form-control"/>
    </div>

    <g:hiddenField name="source" value="${source}"/>

    <div class="control-group">
        <button type="button" class="btn btn-primary" id="btnSubmit"><i></i> Create question</button>
    </div>
</form>
</body>

<r:script>

    $(document).ready(function() {

      $("#btnCancel").click(function(e) {
        e.preventDefault();
        location.href = "${createLink(controller: 'question', action: 'list')}";
      });

      $("#btnSubmit").click(function(e) {

        e.preventDefault();

        hideError();

        var question = {
            userId: "<to:currentUserId/>",
            occurrenceId: $("#occurrenceId").val(),
            questionType: $("#questionType").val(),
            tags: $("#tags").val(),
            source: $("#source").val()
        };

        tolib.doJsonPost("${createLink(controller: 'webService', action: 'createQuestionFromExternal')}", question).done(function(response) {
            if (response.success) {
                $("#btnSubmit").find('i').addClass('fa fa-cog fa-spin');
                setTimeout(function() {
                    location.href = "${createLink(controller: 'question', action: 'list')}";
                }, 3000);
            } else {
                displayError(response.message);
            }
        }).error(function() {
            displayError("An internal error occurred on the server!");
        });

      });

    });

    function doJsonPost(url, data) {
        var dataStr = JSON.stringify(data);
        return $.ajax({
            type:'POST',
            url: url,
            contentType:'application/json',
            data: dataStr
        });
    }

    function displayError(message) {
        var div = $("#errorMessageDiv");
        div.html(message);
        div.css('display', 'block');
    }

    function hideError() {
        var div = $("#errorMessageDiv");
        div.html("");
        div.css('display', 'none');
    }

</r:script>

</html>
