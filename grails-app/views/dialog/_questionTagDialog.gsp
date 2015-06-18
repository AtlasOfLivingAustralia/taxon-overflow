<%@ page import="grails.converters.JSON" %>
<%@page expressionCodec="none" %>
<g:form name="addTagForm" controller="webService" action="addTagToQuestion" class="form-horizontal">
    <g:hiddenField name="questionId" value="${question.id}"/>
    <div class="modal fade" id="addTagModalDialog" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">Add Tags</h4>
                </div>
                <div class="modal-body">
                    <div class="alert alert-danger" role="alert" style="display: none;">
                        <span class="alertText"></span>
                    </div>
                    <div class="form-group">
                        <label for="tags" class="col-md-2 control-label">Tags</label>
                        <div class="col-sm-10">
                            %{--<g:textField class="form-control" name="tags" placeholder="Enter one or more tags"/>--}%
                            <input type="text" id="tags" class="form-control select2" multiple="true" name="tags"/>
                            <span class="help-block">Start typing to select existing tags or add new ones separated by comma</span>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" id="submitTagButton">Add tags</button>
                </div>
            </div>
        </div>
    </div>
</g:form>
<script>
    var tags = ${(raw(tags as grails.converters.JSON).toString())};
    $("#tags").select2({
            tags: ${(raw(tags.collect {it.id} as grails.converters.JSON).toString())},
            tokenSeparators: [','],
            placeholder:"Enter one or more tags"
    });

    $('#addTagModalDialog').on('shown.bs.modal', function () {
        $("#tags").select2('focus');
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