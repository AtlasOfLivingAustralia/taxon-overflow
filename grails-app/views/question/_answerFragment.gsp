<style>

    .voteCount {
        font-size: large;
        font-weight: bold;
        margin-top: 5px;
        margin-bottom: 5px;
    }

    .answerCommentsContainer {
        border-top: 1px solid lightgray;
    }

    .comment-list {
        list-style: none;
        margin-left: 0;
    }

    .comment-list li {
        padding: 10px;
        border-bottom: 1px solid #dddddd;
    }

    .btnDeleteComment, .btnDeleteComment:hover, .btnDeleteComment:visited {
        padding: 5px;
        color: dimgrey;
        border: 1px solid transparent;
    }

    .btnDeleteComment:hover {
        border: 1px solid #dddddd;
        border-radius: 3px;
    }

    .vote-arrow {
        font-size: 1.5em;
        border: 1px solid #dddddd;
        border-radius: 3px;
        padding: 3px;
        text-decoration: none;
        color: dimgray;
    }

    a.vote-arrow, a.vote-arrow:hover, a.vote-arrow:visited {
        text-decoration: none;
        color: dimgray;
    }

    .vote-arrow-up {
    }

    .vote-arrow-down {
    }

    .striped {
        background-color: #F9F9F9;
    }

    .accepted-answer-mark {
        font-size: 4em;
        color: green;
    }

    .user-upvoted, .user-upvoted:hover {
        color: green  !important;
        font-size: 1.6em;
    }

    .user-downvoted, .user-downvoted:hover {
        color: orangered !important;
        font-size: 1.6em;
    }

    .answer-buttons .btn i {
        font-size: 1.2em;
    }

    .answer-buttons .btn.btnDeleteAnswer i {
        color: red;
    }

    .answer-buttons .btn.btnAcceptAnswer i {
        color: green;
    }


</style>
<div class="row-fluid">

    <div class="span1">
        <g:if test="${answer.accepted}">
            <to:ifCanAcceptAnswer answer="${answer}">
                <a href="#" title="Click to undo acceptance of this answer." class="btnUnacceptAnswer">
                    <i class="accepted-answer-mark fa fa-check"></i>
                </a>
            </to:ifCanAcceptAnswer>
            <to:ifCannotAcceptAnswer answer="${answer}">
                <i class="accepted-answer-mark fa fa-check"></i>
            </to:ifCannotAcceptAnswer>
        </g:if>
    </div>

    <div class="span1" style="text-align: center">
        <g:set var="upvoteClass" value="${userVote?.voteValue > 0 ? 'user-upvoted' : '' }" />
        <g:set var="downvoteClass" value="${userVote?.voteValue && userVote?.voteValue < 0 ? 'user-downvoted' : '' }" />
        <div>
            <a href="#" class="btnUpVote vote-arrow vote-arrow-up ${upvoteClass}">
                <i class="fa fa-thumbs-o-up"></i>
            </a>
        </div>
        <div class="voteCount">${totalVotes ?: 0}</div>
        <div>
            <a href="#" class="btnDownVote vote-arrow vote-arrow-down ${downvoteClass}">
                <i class="fa fa-thumbs-o-down"></i>
            </a>
        </div>

    </div>

    <div class="span2">
        <to:userDisplayName user="${answer.user}" />
        <br />
        <g:formatDate date="${answer.dateCreated}" format="yyyy-MM-dd" />
    </div>
    <div class="span5" style="font-size: 1.2em">
        <g:render template="/question/show${question.questionType.toString()}Answer" model="${[answer: answer]}" />
    </div>
    <div class="span3">
        <span class="pull-right answer-buttons">
            <to:ifCanEditAnswer answer="${answer}">
                <button type="button" title="Edit this answer" class="btnEditAnswer btn btn-small"><i class="fa fa-edit"></i></button>
                <button type="button" title="Remove this answer" class="btnDeleteAnswer btn btn-small"><i class="fa fa-remove"></i></button>
            </to:ifCanEditAnswer>

            <g:if test="${!answer.accepted}">
                <to:ifCanAcceptAnswer answer="${answer}">
                    <button type="button" title="Accept this answer" class="btnAcceptAnswer btn btn-small"><i class="fa fa-check"></i></button>
                </to:ifCanAcceptAnswer>
            </g:if>
        </span>
    </div>
</div>

<div class="row-fluid">
    <div class="span10 offset2 answerCommentsContainer">
        <ul class="comment-list">
            <g:each in="${answer.comments}" var="comment">
                <li answerCommentId="${comment.id}">
                    <g:render template="commentFragment" model="${[comment: comment]}" />
                </li>
            </g:each>
        </ul>
        <div class="newCommentDiv">
            <a class="btnAddAnswerComment"  href="#">Add a comment...</a>
        </div>
    </div>
</div>