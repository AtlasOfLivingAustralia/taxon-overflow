<aa:zone id="answersZone">
    <a aa-refresh-zones="answersZone" id="refreshAnswersLink" href="${g.createLink(controller: 'question', action: 'answers', id: question.id)}" class="hidden">Refresh</a>
    <div class="padding-bottom-1">
        <!-- Alert page information -->
        <div class="alert alert-info alert-dismissible" role="alert">
            <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <strong>Add your identification answers.</strong>
            Add an answer to the topic question or add comments to existing answers.
        </div>
        <!-- End alert page information -->
    </div>
    <div class="btn-group padding-bottom-1">
        <!-- <p>Help the ALA by adding an answer or comments to existing answers.</p> -->
        <a class="btn btn-primary btn-lg" href="${g.createLink(controller: 'dialog', action: 'addAnswerDialog', id: question.id)}"
           aa-refresh-zones="answerDialogZone"
           aa-js-after="$('#answerModalDialog').modal('show')">
            Add an identification
        </a>
    </div>

    <g:if test="${!answers || answers.size == 0}">
        <p>No answers posted yet.</p>
    </g:if>
    <g:each in="${answers}" var="answer">
        <g:render template="answer" model="[answer: answer, userVotes: userVotes, answerVoteTotals: answerVoteTotals]"/>
    </g:each>
</aa:zone>
<aa:zone id="answerDialogZone"></aa:zone>
<script>
    $(document).on('click', '.thumbs', function(e) {
        e.preventDefault();
        $(this).find('i').removeClass(function (index, css) {
            return (css.match (/(^|\s)fa-thumbs-\S+/g) || []).join(' ');
        }).addClass('fa-cog fa-spin');
        $.get($(this).attr('href'), function(data){
            if (data.success) {
                $("#refreshAnswersLink").click();
            }
        })
    });

    $(document).on('click', '.removeAnswerCommentButton', function(e) {
        e.preventDefault();
        var params = {
            'userId': '${to.currentUserId()}',
            'commentId': $(this).attr('comment-id')
        };
        var url = $(this).attr('href');
        bootbox.confirm("Are you sure you want to delete the comment?", function(result){
            if (result) {
                var response = tolib.doAjaxRequest(url, params, 'DELETE');
                response.done(function(data) {
                    if (data.success) {
                        $("#refreshAnswersLink").click();
                    } else {
                        bootbox.alert(data.message);
                    }
                });
            }
        });
    });

    $(document).on('click', '.accept-answer-btn', function(e) {
        e.preventDefault();
        var url = $(this).attr('href');
        var text = url.indexOf('unaccept') < 0 ? 'mark' : 'unmark';
        bootbox.confirm("Are you sure you want to <strong>" + text + "</strong> this answer as the correct one?", function(result){
            if (result) {
                var response = tolib.doAjaxRequest(url, {}, 'PUT');
                response.done(function(data) {
                    if (data.success) {
                        $("#refreshAnswersLink").click();
                    } else {
                        bootbox.alert(data.message);
                    }
                });
            }
        });
    });

    $(document).on('click', '.delete-answer-btn', function(e) {
        e.preventDefault();
        var url = $(this).attr('href');
        bootbox.confirm("Are you sure you want to removed the selected answer?", function(result){
            if (result) {
                var response = tolib.doAjaxRequest(url, {}, 'DELETE');
                response.done(function(data) {
                    if (data.success) {
                        $("#refreshAnswersLink").click();
                    } else {
                        bootbox.alert(data.message);
                    }
                });
            }
        });
    });
</script>
