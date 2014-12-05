<div class="row-fluid" style="margin-top: 10px">
    <div class="span10">
        <g:textArea class="span12" name="comment" rows="2"/>
    </div>
    <div class="span2">
        <button type="button" id="btnAddQuestionComment" class="btn btn-small btnAddQuestionComment">Add comment</button>
    </div>
</div>

<script>

    $("#comment").focus();

    $("#btnAddQuestionComment").click(function(e) {
        e.preventDefault();
        var comment = $("#comment").val();
        if (comment) {
            var data = {
                questionId: ${question.id},
                comment: comment,
                userId: "<to:currentUserId />"
            };
            tolib.doJsonPost("${createLink(controller:'webService', action:'addQuestionComment')}", data).done(function(response) {
                if (response.success) {
                    // redraw this answer...
                    if (renderQuestionComments && renderQuestionComments instanceof Function) {
                        renderQuestionComments();
                    }
                } else {
                    alert(response.message);
                }
            });
        }
    });

</script>