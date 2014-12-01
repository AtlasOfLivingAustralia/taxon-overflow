<div class="row-fluid">
    <div class="span12 editAnswerDiv">
        <to:renderAnswerTemplate question="${answer.question}" answer="${answer}" />
    </div>
</div>

<div class="row-fluid">
    <div class="span12">
        <div class="pull-right">
            <button type="button" class="btn" id="btnCancelEditAnswer">Cancel</button>
            <button type="button" class="btn btn-primary" id="btnSaveAnswer">Save</button>
        </div>
    </div>
</div>

<script>

    $("#btnCancelEditAnswer").onClick(function(e) {
        e.preventDefault();
        tolib.hideModal();
    });

    $("#btnSaveAnswer").onClick(function(e) {
        e.preventDefault();

        var answer = { answerId: ${answer.id}, userId: "${user.alaUserId}" };

        $(".editAnswerDiv .answer-field").each(function() {
            answer[$(this).attr("id")] = $(this).val();
        });

        $.post("${createLink(controller: 'webService', action:'updateAnswer', id:answer.id)}", answer, null, "application/json").done(function(response) {
            if (response.success) {
                renderAnswers();
                if (options && options.onSuccess instanceof Function) {
                    options.onSuccess();
                }
            } else {
                alert(response.message);
                if (options && options.onFailure instanceof Function) {
                    options.onFailure();
                }
            }
        }).always(function() {
            if (options && options.onComplete instanceof Function) {
                options.onComplete();
            }
        });

    });


</script>