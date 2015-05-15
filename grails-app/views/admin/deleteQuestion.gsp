<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="to-admin"/>
    <title>Dashboard</title>
</head>

<body class="content">
<content tag="menuItemId">delete-question</content>

<h2 class="heading-medium">Delete Question</h2>

<g:set var="alertClass" value="hidden"/>
<g:if test="${flash.error}">
    <g:set var="alertClass" value="alert-danger"/>
</g:if>
<g:elseif test="${flash.success}">
    <g:set var="alertClass" value="alert-success"/>
</g:elseif>

<div class="alert ${alertClass}">
    <ul>
        <g:each in="${flash?.error}" var="errorMsg">
            <li>${errorMsg}</li>
        </g:each>
        <g:each in="${flash?.success}" var="successMsg">
            <li>${successMsg}</li>
        </g:each>
    </ul>
</div>

<g:form action="doDeleteQuestion" name="deleteQuestionForm" method="post" class="col-md-9">

    <div class="form-group">
        <label class="control-label">Question Id</label>
        <g:field type="number" name="questionId" class="form-control" value="${flash.questionId}"/>
    </div>

    <div class="control-group">
        <button type="submit" class="btn btn-primary" id="btnSubmit"><i></i> Delete question</button>
    </div>
</g:form>

</body>
</html>
