<div class="row-fluid comment-fragment">
    <div class="span11">
        ${comment.comment}
        <br/>
        <small>
            <to:userDisplayName user="${comment.user}" /> - <prettytime:display date="${comment.dateCreated}" />
        </small>
    </div>
    <div class="span1">
        <to:ifCanEditComment comment="${comment}">
            <a href="#" class="${deleteCommentClass ?: "btnDeleteComment"}" title="Remove your comment  "><i class="fa fa-remove"></i></a>
        </to:ifCanEditComment>
    </div>
</div>
