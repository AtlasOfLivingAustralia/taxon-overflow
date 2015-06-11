<g:set var="disableTagFollow" value="${true}"/>
<to:ifUserIsLoggedIn>
    <g:set var="disableTagFollow" value="${false}"/>
</to:ifUserIsLoggedIn>
<h3 class="font-xxsmall">Filter by tags</h3>
<aa:zone id="aggregatedTagsZone">
<ul id="tagsFacet">
    <g:each in="${tags}" var="tag">
        <g:set var="selectedTags" value="${params.f?.tags?: []}"/>
        <g:set var="isFollowingTag" value="${tagsFollowing?.contains(tag.label)}"/>
        <li><span id="aggregatedTag-${tag.label}" class="label ${selectedTags.contains(tag.label) ? 'label-success' : 'label-default'} ${disableTagFollow ? '' : 'follow-tag'} tag"
                  data-trigger="manual" data-html="true" data-placement="right"
                  data-container="body" data-toggle="popover"
                  data-content="<a href='${g.createLink(controller: 'webService', action: isFollowingTag ? 'unfollowTag': 'followTag', params: [tag: tag.label])}' class='btn tag-follow-button'><i class='fa ${isFollowingTag ? 'fa-star' : 'fa-star-o'}'></i> ${isFollowingTag ? 'Following' : 'Follow'}</a>">${tag.label}</span> × ${tag.count}</li>
    </g:each>
</ul>
</aa:zone>


