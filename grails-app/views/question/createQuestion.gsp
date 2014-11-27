<!DOCTYPE html>
<html>
  <head>
    <meta name="layout" content="tomain"/>
    <title>Welcome to Grails</title>
    <style type="text/css" media="screen">
    </style>

  </head>
  <body class="content">
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
        var question = {
            userId: "<to:currentUserId />",
            occurrenceId: $("#occurrenceId").val(),
            questionType: $("#questionType").val(),
            tags: $("#tags").val()

        };

        $.post("${createLink(controller:'webService', action:'createQuestionFromBiocache')}", question, null, "json").done(function(response) {
            if (response.success) {
                location.href = "${createLink(controller:'question', action:'list')}";
            } else {
                alert(response.message)
            }
        });

      });

    });

  </r:script>

</html>
