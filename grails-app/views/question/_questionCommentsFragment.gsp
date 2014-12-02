<style>
    .question-comment-list {
        list-style: none;
        margin-left: 0;
    }

    .question-comment-list li {
        padding: 10px;
        border-bottom: 1px solid #dddddd;
    }

</style>
<div class="row-fluid">
    <div class="span11 offset1">
        <ul class="question-comment-list">
            <g:each in="${question.comments}" var="questionComment">
                <li questionCommentId="${questionComment.id}">
                    <g:render template="commentFragment" model="${[comment:questionComment, deleteCommentClass:"btnDeleteQuestionComment"]}" />
                </li>
            </g:each>
        </ul>
        <div id="newQuestionCommentDiv">
            <a id="btnAddQuestionComment" href="#">Add a comment...</a>
        </div>

    </div>
</div>

<script>

    $("#btnAddQuestionComment").click(function(e) {
        e.preventDefault();
        $.ajax("${createLink(controller:'question', action:'addQuestionCommentFragment', id: question.id)}").done(function(content) {
            $("#newQuestionCommentDiv").html(content);
        });

    });

    $(".btnDeleteQuestionComment").click(function(e) {
        e.preventDefault();
        var questionCommentId = $(this).closest("[questionCommentId]").attr("questionCommentId");
        if (questionCommentId) {

            var commentData = {
                commentId: questionCommentId,
                userId: "<to:currentUserId />"
            };

            tolib.doJsonPost("${createLink(controller:'webService', action:'deleteQuestionComment')}", commentData).done(function(response) {
                if (renderQuestionComments && renderQuestionComments instanceof Function) {
                    renderQuestionComments();
                }
            });
        }
    });

</script>