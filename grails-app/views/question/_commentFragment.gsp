<div class="row-fluid comment-fragment">
    <div class="span11">
        ${comment.comment}
        <br/>
        <small>
            <to:userDisplayName user="${comment.user}" /> - <g:formatDate date="${comment.dateCreated}" format="yyyy-MM-dd HH:mm:ss" />
        </small>
    </div>
    <div class="span1">
        <to:ifCanEditComment comment="${comment}">
            <a href="#" class="${deleteCommentClass ?: "btnDeleteComment"}"><i class="fa fa-remove"></i></a>
        </to:ifCanEditComment>
    </div>
</div>
