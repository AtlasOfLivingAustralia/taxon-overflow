<style>

    .voteCount {
        font-size: large;
        font-weight: bold;
        margin-top: 5px;
        margin-bottom: 5px;
    }

    .answerCommentsContainer {
        border-top: 1px dotted #dddddd;
    }

    .comment-list {
        list-style: none;
        margin-left: 0;
    }

    .comment-list li {
        padding: 10px;
        border-bottom: 1px dotted #dddddd;
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
        font-size: 3em;
        color: green;
        border: 1px solid transparent;
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

    .accepted-answer-mark:hover {
        border: 1px solid green;
        border-radius: 3px;
    }

    .answer-buttons .btn.btnDeleteAnswer i {
        color: red;
    }

    .answer-buttons .btn.btnAcceptAnswer i {
        color: green;
    }

    .identification-answer h3 { padding-top:0px; margin-top:0px;  }

    .accepted-answer-header { padding-top:0px; margin-top:0px; background-color: darkgreen; color: #FFF }

    .answer-container { padding:0px; }

    .answer-main { font-size:18px;margin-top: 10px; }
    .answer-details { }

</style>
<div class="answer-container ${ answer.accepted ? 'accepted-answer' : ''}">
    <g:if test="${answer.accepted}"><h3 class="accepted-answer-header">Accepted answer</h3></g:if>
    <div class="answer-details row-fluid" style="margin-bottom: 10px">
        <div class="span9" style="padding-left:10px;">
            <div class="identification-answer">
                <g:render template="/question/show${question.questionType.getCamelCaseName()}Answer" model="${[answer: answer]}" />
            </div>
            <div class="whoWhen">
                Identified by <strong><to:userDisplayName user="${answer.user}" /></strong> <prettytime:display date="${answer.dateCreated}" />
                <to:ifCanEditAnswer answer="${answer}">
                    <a href="#" title="Edit this answer" class="btnEditAnswer"><i class="fa fa-edit"></i></a>
                    <a href="#" title="Remove this answer" class="btnDeleteAnswer"><i class="fa fa-remove"></i></a>
                </to:ifCanEditAnswer>
            </div>
        </div>

        <div class="span1"style="text-align: center; margin-top:20px;">
            <span class="pull-right answer-buttons">
                <g:if test="${!answer.accepted}">
                    <to:ifCanAcceptAnswer answer="${answer}">
                        <button type="button" title="Accept this answer" class="btnAcceptAnswer btn btn-small"><i class="fa fa-check"></i></button>
                    </to:ifCanAcceptAnswer>
                </g:if>
            </span>
        </div>

        <div class="span1" style="text-align: center; margin-top:10px;">
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

        <div class="span1" style="text-align: center;  margin-top:15px;">
            <g:set var="upvoteClass" value="${userVote?.voteValue > 0 ? 'user-upvoted' : '' }" />
            <g:set var="downvoteClass" value="${userVote?.voteValue && userVote?.voteValue < 0 ? 'user-downvoted' : '' }" />
            <div>
                <a href="#" class="btn btnUpVote vote-arrow vote-arrow-up ${upvoteClass}">
                    <i class="fa fa-thumbs-o-up"></i>
                </a>
            </div>
            <div class="voteCount">${totalVotes ?: 0}</div>
            <div>
                <a href="#" class="btn btnDownVote vote-arrow vote-arrow-down ${downvoteClass}">
                    <i class="fa fa-thumbs-o-down"></i>
                </a>
            </div>
        </div>

    </div>
    <div class="answer-details row-fluid">
        <div class="span11 offset1 answerCommentsContainer">
            <ul class="comment-list">
                <g:each in="${answer.comments}" var="comment">
                    <li answerCommentId="${comment.id}">
                        <g:render template="commentFragment" model="${[comment: comment]}" />
                    </li>
                </g:each>
            </ul>
            <div class="newCommentDiv">
                <a class="btnAddAnswerComment btn btn-mini"  href="#">Add a comment on this identification...</a>
            </div>
        </div>
    </div>
</div>