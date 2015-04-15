<div class="btn-group padding-bottom-1 pull-right">
    <a class="btn btn-default ${isFollowing ? 'active' : ''}" title="${isFollowing ? 'Click to unfollow' : 'Click to follow'}" href="#" id="followQuestionButton">
        <i class="fa ${isFollowing ? 'fa-star' : 'fa-star-o'}"></i>
        <span class="hidden-xs" style="${!isFollowing ? 'display:none' : ''}"> Following</span>
        <span class="hidden-xs" style="${isFollowing ? 'display:none' : ''}"> Follow</span>
    </a>
    <to:ifCanEditQuestion question="${question}">
        <a class="btn btn-default" href="${g.createLink(controller: 'dialog', action: 'addQuestionTagDialog', params: [questionId: question.id])}"
           aa-refresh-zones="addTagDialogZone" id="btnSaveTag"
           aa-js-after="$('#addTagModalDialog').modal('show')">
            <i class="fa fa-tag"></i> Add Tag</a>
        <aa:zone id="addTagDialogZone"></aa:zone>
    </to:ifCanEditQuestion>
</div>
<a aa-refresh-zones="followingZone" href="${createLink(controller:'question', action:'followingFragment', id: question.id)}" id="refreshFollowingZoneLink" style="display: none;">Refresh</a>