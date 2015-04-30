<g:set var="disableActivitySummaryBtn" value="${true}"/>
<to:ifUserIsLoggedIn>
    <g:set var="disableActivitySummaryBtn" value="${false}"/>
</to:ifUserIsLoggedIn>

<div class="col-sm-3 activity-summary">
    <g:if test="${disableActivitySummaryBtn}">
        <span class="disable-btn-tooltip" data-placement="bottom">
    </g:if>
    <a class="btn btn-primary" href="${g.createLink(uri: '/user')}" ${disableActivitySummaryBtn ? 'disabled="disabled"' : ''}>Your activity summary</a>
    <g:if test="${disableActivitySummaryBtn}">
        <span class="disable-btn-tooltip" data-placement="top">
    </g:if>
</div>
