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

<r:script>

    $("#btnCancelEditAnswer").click(function(e) {
        e.preventDefault();
        tolib.hideModal();
    });

    $("#btnSaveAnswer").click(function(e) {

        e.preventDefault();

        var answer = { answerId: ${answer.id}, userId: "${user.alaUserId}" };

        $(".editAnswerDiv .answer-field").each(function() {
            answer[$(this).attr("id")] = $(this).val();
        });

        tolib.doJsonPost("${createLink(controller: 'webService', action:'updateAnswer', id:answer.id)}", answer).done(function(response) {
            if (response.success) {
                renderAnswers();
                tolib.hideModal();
            } else {
                alert(response.message);
            }
        }).error(function() {
            alert("error");
        });
    });


</r:script>