<!DOCTYPE html>
<html>
  <head>
    <meta name="layout" content="tomain"/>
    <title>Welcome to Grails</title>
    <style type="text/css" media="screen">

    </style>
    <r:script>
      $(document).ready(function() {
      });
    </r:script>

  </head>
  <body class="content">
    <g:form action="createQuestionFromOccurrenceId" class="form-horizontal">

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
        <button type="button" class="btn">Cancel</button>
        <button type="submit" class="btn btn-primary">Create question</button>
      </div>
    </g:form>
  </body>
</html>
