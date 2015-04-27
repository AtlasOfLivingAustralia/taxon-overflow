
<h3 class="font-xxsmall">Filter by type</h3>
<aa:zone id="aggregatedTagsZone">
<ul id="tagsFacet">
    <g:each in="${tags}" var="tag">
        <g:set var="selectedTags" value="${params.f?.tags?: []}"/>
        <g:set var="isFollowingTag" value="${tagsFollowing?.contains(tag.label)}"/>
        <li><span id="aggregatedTag-${tag.label}" class="label ${selectedTags.contains(tag.label) ? 'label-success' : 'label-default'} tag tag_${tag.label}"
                    data-trigger="manual" data-html="true"
                    data-container="body" data-toggle="popover"
                    data-content="<a href='${g.createLink(controller: 'webService', action: isFollowingTag ? 'unfollowTag': 'followTag', params: [tag: tag.label])}' class='btn tag-follow-button'><i class='fa ${isFollowingTag ? 'fa-star' : 'fa-star-o'}'></i> ${isFollowingTag ? 'Following' : 'Follow'}</a>">${tag.label}</span> × ${tag.count}</li>
    </g:each>
</ul>

    <script>
        $(function() {
            var counter;
            $('.tag').popover({}).on("mouseenter", function () {
                var _this = this;
                taxonoverflow.setActivePopoverTag($(this).attr('id'));
                clearTimeout(counter);
                counter = setTimeout(function () {
                    $(_this).popover("show");
                    $(".popover").on("mouseleave", function () {
                        $(_this).popover('hide');
                        taxonoverflow.clearActivePopoverTag();
                    });
                }, 400);
            }).on("mouseleave", function () {
                var _this = this;
                setTimeout(function () {
                    if (!$(".popover:hover").length) {
                        $(_this).popover("hide");
                        taxonoverflow.clearActivePopoverTag();
                    }
                }, 300);
            });

            taxonoverflow.showActivePopoverTag();
        });
    </script>
</aa:zone>

<a aa-refresh-zones="aggregatedTagsZone" id="refreshAggregatedTagsLink" href="${g.createLink(action: 'showAggregatedTags')}" class="hidden">Refresh</a>

