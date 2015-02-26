<!DOCTYPE html>
<html>
  <head>
    <meta name="layout" content="main"/>
    <title>Create question | Atlas of Living Australia</title>
    <r:require modules="application"/>
  </head>
  <body class="content">

    <h1>Debug create ${source}  question form (not intended for public use)</h1>

    <div class="alert alert-error" style="display: none" id="errorMessageDiv"></div>

    <div class="form-horizontal">

      <div class="control-group">
        <label class="control-label">Occurrence Id</label>
        <div class="controls">
          <g:textField name="occurrenceId" class="input-xlarge" />
        </div>
      </div>

      <div class="control-group">
        <label class="control-label">Question type</label>
        <div class="controls">
          <g:select name="questionType" from="${au.org.ala.taxonoverflow.QuestionType.values()}" value="${au.org.ala.taxonoverflow.QuestionType.Identification}"/>
        </div>
      </div>

      <div class="control-group">
        <label class="control-label">Tags (comma separated)</label>
        <div class="controls">
          <g:textField name="tags" class="input-xxlarge" />
        </div>
      </div>

        <g:hiddenField name="source" value="${source}"/>

      <div class="control-group">
        <button type="button" class="btn" id="btnCancel">Cancel</button>
        <button type="button" class="btn btn-primary" id="btnSubmit">Create question</button>
      </div>
    </div>
  </body>

  <r:script>

    $(document).ready(function() {

      $("#btnCancel").click(function(e) {
        e.preventDefault();
        location.href = "${createLink(controller:'question', action:'list')}";
      });

      $("#btnSubmit").click(function(e) {

        e.preventDefault();

        hideError();

        var question = {
            userId: "<to:currentUserId />",
            occurrenceId: $("#occurrenceId").val(),
            questionType: $("#questionType").val(),
            tags: $("#tags").val(),
            source: $("#source").val()
        };

        tolib.doJsonPost("${createLink(controller:'webService', action:'createQuestionFromExternal')}", question).done(function(response) {
            if (response.success) {
                location.href = "${createLink(controller:'question', action:'list')}";
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
