<div>

    <div class="row-fluid">
        <div class="span12">
            <div class="form-horizontal">
                <div class="control-group">
                    <label for="tag" class="control-label">Tag</label>
                    <div class="controls">
                        <g:textField class="span8 answer-field" name="tag" value="" />
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row-fluid">
        <div class="span12">
            <div class="pull-right">
                <button type="button" class="btn" id="btnCancelAddTag">Cancel</button>
                <button type="button" class="btn btn-primary" id="btnAddTag">Add tag</button>
            </div>
        </div>
    </div>

</div>

<script>

    function addTagToQuestion() {
        var tag = $("#tag").val();
        var data = {
            questionId: ${question.id},
            tag: tag
        };

        tolib.doJsonPost("${createLink(controller:'webService', action:'addTagToQuestion')}", data).done(function(response) {

            console.log(response);

            if (response.success) {
                tolib.hideModal();
            } else {
                alert(reponse.message);
            }
        });
    }

    $("#btnCancelAddTag").click(function(e) {
        e.preventDefault();
        tolib.hideModal();
    });

    $("#btnAddTag").click(function(e) {
        e.preventDefault();
        addTagToQuestion();
    });

    $("#tag").keydown(function(e) {
        if (e.keyCode == 13) {
            addTagToQuestion();
        }
    });

    $("#tag").focus();

</script>