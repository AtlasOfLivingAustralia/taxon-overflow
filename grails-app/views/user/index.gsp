<%--
  Created by IntelliJ IDEA.
  User: dos009@csiro.au
  Date: 19/03/15
  Time: 5:00 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Taxon Overflow - Activity Summary</title>
    <meta name="layout" content="tomain"/>
    <r:require modules="core"/>
</head>
<body>
<div class="row">
    <div class="span12">
        <ul class="breadcrumb">
            <li><a href="${g.createLink(uri:'/')}">Home</a> <span class="divider"><i class="fa fa-arrow-right"></i></span></li>
            <li class="active">Activity Summary</li>
        </ul>
    </div>
</div>
<h1>${(user.displayName) ? user.displayName + "'s" : "My"} Activity Summary</h1>
<div class="taxonoverflow-content row-fluid">
    <div class="span4">
        <h4>My Questions</h4>
        <g:render template="listQuestions" model="[questionList: myQuestions, questionLabel: 'questions']"/>
    </div>
    <div class="span4">
        <h4>My Answers</h4>
        <g:render template="listQuestions" model="[questionList: myAnsweredQuestions, questionLabel: 'answers']"/>
    </div>
    <div class="span4">
        <h4>Followed Questions</h4>
        <g:render template="listQuestions" model="[questionList: followedQuestions, questionLabel: 'followed questions']"/>
    </div>
</div>
</body>
</html>