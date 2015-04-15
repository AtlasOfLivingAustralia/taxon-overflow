<g:form name="addTagForm" controller="webService" action="addTagToQuestion" class="form-horizontal">
    <g:hiddenField name="questionId" value="${question.id}"/>
    <div class="modal fade" id="addTagModalDialog" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">Add Tag</h4>
                </div>
                <div class="modal-body">
                    <div class="alert alert-danger alert-dismissable" role="alert" style="display: none;">
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <span class="alertText"></span>
                    </div>
                    <div class="form-group">
                        <label for="tag" class="col-md-2 control-label">Tag</label>
                        <div class="col-sm-10">
                            <g:textField class="form-control" name="tag" />
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" id="submitTagButton">Add tag</button>
                </div>
            </div>
        </div>
    </div>
</g:form>
<script>
    $('#addTagModalDialog').on('shown.bs.modal', function () {
        $("#tag").focus();
    });

    $('#addTagForm input').on('keypress', function(e){
        if (e.which == 13) {
            e.preventDefault();
            $('#submitTagButton').click();
        }
    });

    $('#submitTagButton').on('click', function(e) {
        e.preventDefault();
        var response = tolib.doAjaxRequest($("#addTagForm").attr('action'), tolib.serializeFormJSON($("#addTagForm")));
        response.done(function(data) {
            if (data.success) {
                $("#addTagModalDialog").modal('hide');
                $("#refreshTagsLink").click();
            } else {
                $("#addTagForm .alertText").text(data.message);
                $("#addTagForm .alert").show();
            }
        });
    });
</script>