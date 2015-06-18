<g:set var="disableFollowBtn" value="${true}"/>
<to:ifUserIsLoggedIn>
    <g:set var="disableFollowBtn" value="${false}"/>
</to:ifUserIsLoggedIn>
<div class="btn-group padding-bottom-1 pull-right">
    <g:if test="${disableFollowBtn}">
    <span class="disable-btn-tooltip" data-placement="top">
    </g:if>
    <a class="btn btn-default ${isFollowing ? 'active' : ''}" title="${isFollowing ? 'Click to unfollow' : 'Click to follow'}"
       href="#" id="followQuestionButton" ${disableFollowBtn ? 'disabled=disabled' : ''}>
        <i class="fa ${isFollowing ? 'fa-star' : 'fa-star-o'}"></i>
        <span class="hidden-xs" style="${!isFollowing ? 'display:none' : ''}"> Following</span>
        <span class="hidden-xs" style="${isFollowing ? 'display:none' : ''}"> Follow</span>
    </a>
    <g:if test="${disableFollowBtn}">
    </span>
    </g:if>
    <to:ifCanEditQuestion question="${question}">
    <a class="btn btn-default" href="${g.createLink(controller: 'dialog', action: 'addQuestionTagDialog', id: question.id)}" ${disableAddTagBtn ? 'disabled="disabled"' : ''}
       title="Add tag"
       aa-refresh-zones="addTagDialogZone" id="btnSaveTag"
       aa-js-after="$('#addTagModalDialog').modal('show')">
        <i class="fa fa-tag"></i><span class="hidden-xs"> Add Tags</span></a>
    </to:ifCanEditQuestion>
    <aa:zone id="addTagDialogZone"></aa:zone>
</div>
<a aa-refresh-zones="followingZone" href="${createLink(controller:'question', action:'followingFragment', id: question.id)}" id="refreshFollowingZoneLink" style="display: none;">Refresh</a>