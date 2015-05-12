<div id="infoAlert4" class="alert alert-info alert-dismissible" role="alert">
    <button info-alert="infoAlert4" type="button" class="close info-alert-close-btn" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
    <strong>Add comments or questions.</strong>
    Add comments to the existing topic question answers.
</div>
<aa:zone id="commentsZone">
    <g:set var="disableAddCommentForm" value="${true}"/>
    <to:ifUserIsLoggedIn>
        <g:set var="disableAddCommentForm" value="${false}"/>
    </to:ifUserIsLoggedIn>
    <g:form name="addCommentForm" controller="webService" action="addQuestionComment" class="form-horizontal padding-bottom-1">
        <g:hiddenField name="userId" value="${to.currentUserId()}"/>
        <g:hiddenField name="questionId" value="${question.id}"/>

        <div class="alert alert-danger alert-dismissable" role="alert" style="display: none;">
            <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <span class="alertText"></span>
        </div>

        <div class="form-group">
            <label for="comment" class="col-sm-3 control-label">Comments or questions</label>
            <div class="col-sm-8">
                <g:textArea name="comment" class="form-control" rows="4" placeholder="Enter your comments or questions" ></g:textArea>
            </div>
        </div>
        <div class="form-group">
            <div class="col-sm-offset-3 col-sm-8">
                <g:if test="${disableAddCommentForm}">
                <span class="disable-btn-tooltip" data-placement="bottom">
                </g:if>
                <button type="button" class="btn btn-primary btn-lg" id="submitCommentButton" ${disableAddCommentForm ? 'disabled="disabled"' : ''}><i class="fa fa-gear fa-spin hidden fa-2x"></i> Submit comment</button>
                <g:if test="${disableAddCommentForm}">
                </span>
                </g:if>
            </div>
        </div>
    </g:form>

        <a aa-refresh-zones="commentsZone" id="refreshCommentsLink" href="${g.createLink(controller: 'question', action: 'questionComments', id: question.id)}" class="hidden"></a>

    <g:if test="${!question.comments}">
        <p>No comments posted yet.</p>
    </g:if>
    <div class="comment public_comment">
    <g:each in="${question.comments}" var="questionComment">
        <div class="comment-wrapper push">
            <div class="body">
                <!-- <span class="comment-icon"><i class="fa fa-comment"></i></span> -->
                <div class="col-xs-9 margin-bottom-1">
                    <div class="ident-question">${questionComment.comment}</div>
                    <div class="contrib-time"><prettytime:display date="${questionComment.dateCreated}"/> by <span class="comment-author"><to:userDisplayName user="${questionComment.user}" /></span></div>
                </div>
                <div class="col-md-3">
                    <to:ifCanEditComment comment="${questionComment}">
                    <ul class="list-inline pull-right">
                        <li class=" font-xsmall"><a class="btnRemoveComment" href="${g.createLink(controller: 'webService', action: 'deleteQuestionComment')}" title="Delete comment" comment-id="${questionComment.id}"><i class="fa fa-trash" title="Delete comment"></i></a></li>
                    </ul>
                    </to:ifCanEditComment>
                </div>
            </div>
        </div>
    </g:each>
    </div>

    <script>
        $('#addTagForm textarea').on('keypress', function(e){
            if (e.which == 13) {
                e.preventDefault();
                $('#submitCommentButton').click();
            }
        });

        $('#submitCommentButton').on('click', function(e) {
            e.preventDefault();
            var response = tolib.doAjaxRequest($("#addCommentForm").attr('action'), tolib.serializeFormJSON($("#addCommentForm")));
            response.done(function(data) {
                if (data.success) {
                    $("#refreshCommentsLink").removeClass('hidden');
                    $("#refreshCommentsLink").click();
                } else {
                    $("#addCommentForm .alertText").text(data.message);
                    $("#addCommentForm .alert").show();
                }
            });
        });

        $('.btnRemoveComment').on('click', function(e) {
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
                            $("#refreshCommentsLink").click();
                        } else {
                            bootbox.alert(data.message);
                        }
                    });
                }
            });
        });
    </script>
</aa:zone>