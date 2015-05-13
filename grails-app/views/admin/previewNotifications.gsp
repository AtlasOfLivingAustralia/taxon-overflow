<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="to-admin"/>
    <title>Preview Email Notifications | Atlas of Living Australia</title>
</head>
<body class="content">
<content tag="menuItemId">preview-notifications</content>

<ul class="nav nav-tabs" id="notifications">
    <li class="active"><a href="#comments" data-toggle="tab">Comments</a></li>
    <li><a href="#answers" data-toggle="tab">Answers</a></li>
    <li><a href="#tags" data-toggle="tab">Tags</a></li>
</ul>

<div class="tab-content">
    <div class="tab-pane active" id="comments">
        <br/>
        <p>Last 5 comments:</p>
        <table class="table table-striped table-hover">
            <thead>
            <tr>
                <th>Comment Type</th>
                <th>Question/Answer ID</th>
                <th>Comment</th>
                <th style="width:10%;">Action</th>
            </tr>
            </thead>
            <tbody>
            <g:each in="${comments}" var="comment">
                <tr>
                    <td>
                        ${comment instanceof au.org.ala.taxonoverflow.QuestionComment ? 'Question Comment' : 'Answer Comment'}
                    </td>
                    <td>
                        ${comment instanceof au.org.ala.taxonoverflow.QuestionComment ? comment.questionId : comment.answerId}
                    </td>
                    <td>
                        <i>${comment.comment.length() > 50 ? "\"${comment.comment.substring(0, 49)}...\"" : "\"${comment.comment}\""}</i>
                    </td>
                    <td>
                        <a class="btn btn-primary btn-sm" href="${g.createLink(action: 'previewQuestionCommentNotification', id: comment.id, params: [type: comment instanceof au.org.ala.taxonoverflow.QuestionComment ? '1' : '2'])}" target="_blank" class="btn btn-ala btn-small"> Preview</a>
                    </td>
                </tr>
            </g:each>
            </tbody>
        </table>

    </div>
    <div class="tab-pane" id="answers">
        <br/>
        <p>Last 5 answers:</p>
        <table class="table table-striped table-hover">
            <thead>
            <tr>
                <th>Answer ID</th>
                <th>Scientific Name</th>
                <th>Common Name/s</th>
                <th style="width:10%;">Action</th>
            </tr>
            </thead>
            <tbody>
                <g:each in="${answers}" var="answer">
                    <g:set var="answerProperties" value="${answer ? new groovy.json.JsonSlurper().parseText(answer.darwinCore) : [:]}"/>
                    <tr>
                        <td>${answer.id}</td>
                        <td>${answerProperties?.scientificName}</td>
                        <td>${answerProperties?.commonName}</td>
                        <td>
                            <a class="btn btn-primary btn-sm" href="${g.createLink(action: 'previewAnswerNotification', id: answer.id)}" target="_blank" class="btn btn-ala btn-small"> Preview</a>
                        </td>
                    </tr>
                </g:each>
            </tbody>
        </table>
    </div>
    <div class="tab-pane" id="tags">
        <br/>
        <p>Last 5 tabs:</p>
        <table class="table table-striped table-hover">
            <thead>
            <tr>
                <th>Question ID</th>
                <th>Tab</th>
                <th style="width:10%;">Action</th>
            </tr>
            </thead>
            <tbody>
            <g:each in="${tags}" var="tag">
                <tr>
                    <td>${tag.questionId}</td>
                    <td>${tag.tag}</td>
                    <td>
                        <a class="btn btn-primary btn-sm" href="${g.createLink(action: 'previewTagNotification', id: tag.id)}" target="_blank" class="btn btn-ala btn-small"> Preview</a>
                    </td>
                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
</div>

<script>
    $(function() {
        $('#notifications a').click(function (e) {
            e.preventDefault();
            $(this).tab('show');
        })
    });
</script>
</body>
</html>