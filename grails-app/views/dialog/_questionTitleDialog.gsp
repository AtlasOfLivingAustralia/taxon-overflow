<g:form name="editTitleForm" url="${createLink(uri: '/ws/question/title')}" class="form-horizontal">
    <g:hiddenField name="questionId" value="${question.id}"/>
    <div class="modal fade" id="editTitleModalDialog" role="dialog" aria-labelledby="editTitleModalDialog" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">Edit title</h4>
                </div>
                <div class="modal-body">
                    <div class="alert alert-danger" role="alert" style="display: none;">
                        <span class="alertText"></span>
                    </div>
                    <div class="form-group">
                        <label for="title" class="col-md-3 control-label">Question title</label>
                        <div class="col-sm-9">
                            <g:textField name="title" class="form-control" value="${question.title}" placeholder="Title"/>
                            <span class="help-block">You can customise the title of your question or leave it blank</span>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" id="submitTitleButton">Edit title</button>
                </div>
            </div>
        </div>
    </div>
</g:form>
<script>
    $('#editTitleDialogZone').on('shown.bs.modal', function () {
        $("#title").focus();
    });


    $('#submitTitleButton').on('click', function(e) {
        e.preventDefault();
        var response = tolib.doAjaxRequest($("#editTitleForm").attr('action'), tolib.serializeFormJSON($("#editTitleForm")));
        response.done(function(data) {
            if (data.success) {
                $("#editTitleModalDialog").modal('hide');
                taxonoverflow.clearActivePopoverTag();
                $("#refreshQuestionsListLink").click();
            } else {
                $("#addTagForm .alertText").text(data.message);
                $("#addTagForm .alert").show();
            }
        });
    });
</script>