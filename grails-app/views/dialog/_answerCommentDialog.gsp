<g:form name="answerCommentForm" controller="webService" action="addAnswerComment" class="form-horizontal">
    <g:hiddenField name="answerId" value="${answer.id}"/>
    <g:hiddenField name="userId" value="${to.currentUserId()}"/>
    <div class="modal fade" id="answerCommentModalDialog" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">Add a comment</h4>
                </div>
                <div class="modal-body">
                    <div class="alert alert-danger" role="alert" style="display: none;">
                        <span class="alertText"></span>
                    </div>
                    <div class="form-group">
                        <label for="comment" class="col-md-2 control-label">Comments</label>
                        <div class="col-sm-10 markdown-field">
                            <div class="btn-group" id="comment-preview" role="group" aria-label="toggle-preview">
                                <button class="btn btn-default btn-sm active"><i class="fa fa-pencil"></i> Text</button>
                                <button class="btn btn-default btn-sm"><i class="fa fa-eye"></i> Preview</button>
                            </div>
                            <div class="textarea-edit">
                                <g:textArea class="form-control" name="comment" placeholder="Enter your comment" rows="8"></g:textArea>
                                <span class="help-block">* This field supports <a href="http://daringfireball.net/projects/markdown/syntax" title="Markdown Syntax" target="_blank">Markdown</a> format.</span>
                            </div>
                            <div class="textarea-preview hidden">

                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" id="submitAnswerCommentButton">Add comment</button>
                </div>
            </div>
        </div>
    </div>
</g:form>
<script>
    $('#answerCommentModalDialog').on('shown.bs.modal', function () {
        $("#answerCommentForm #comment").focus();
    });


    $('#submitAnswerCommentButton').on('click', function(e) {
        e.preventDefault();
        var response = tolib.doAjaxRequest($("#answerCommentForm").attr('action'), tolib.serializeFormJSON($("#answerCommentForm")));
        response.done(function(data) {
            if (data.success) {
                $("#answerCommentModalDialog").modal('hide');
                $("#refreshAnswersLink").click();
            } else {
                $("#answerCommentForm .alertText").text(data.message);
                $("#answerCommentForm .alert").show();
            }
        });
    });
</script>