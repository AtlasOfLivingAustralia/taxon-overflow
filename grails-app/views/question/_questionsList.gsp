<aa:zone id="questionsListZone">
<g:each in="${questions}" var="question" status="i">
    <g:set var="questionUrl" value="${createLink(controller:'question', action:'view', id: question.id)}" />
    <g:set var="acceptedAnswer" value="${acceptedAnswers[question]}" />
    <g:set var="occurrence" value="${occurrenceData[question.occurrenceId]}" />
    <div class="comment-wrapper push">
        <div class="body" questionId="${question.id}">
            <div class="col-sm-6">
                <div class="contrib-question">
                    <a href="${questionUrl}">
                        ${question.questionType.label} - #${question.id}</span>
                    </a>
                </div>
                <div class="contrib-time">
                    <g:set var="askedBy" value="${to.userDisplayName(user:question.user)}"/>
                    <g:set var="askedBy" value="${askedBy?:'user not identified'}"/>
                    <prettytime:display date="${question.dateCreated}" /> by <span class="comment-author">${askedBy}</span>
                </div>
                <g:if test="${question.tags && question.tags.size() > 0}">
                <div class="btn-group">
                    <p class="font-xxsmall">Tags:
                        <g:set var="disableTagFollow" value="${true}"/>
                        <to:ifUserIsLoggedIn>
                            <g:set var="disableTagFollow" value="${false}"/>
                        </to:ifUserIsLoggedIn>
                        <g:each in="${question.tags}" var="tag">
                            <g:set var="isFollowingTag" value="${tagsFollowing?.contains(tag.tag)}"/>
                            <a href="#" id="question-${tag.tag}" class="label label-primary ${disableTagFollow ? '' : 'follow-tag'}"
                               data-trigger="manual" data-html="true" data-placement="bottom"
                               data-container="body" data-toggle="popover"
                               data-content="<a href='${g.createLink(controller: 'webService', action: isFollowingTag ? 'unfollowTag': 'followTag', params: [tag: tag.tag])}' class='btn tag-follow-button'><i class='fa ${isFollowingTag ? 'fa-star' : 'fa-star-o'}'></i> ${isFollowingTag ? 'Following' : 'Follow'}</a>">${tag.tag}</a>
                        </g:each>
                    </p>
                </div>
                </g:if>
            </div>
            <div class="col-sm-2">
                <g:if test="${occurrence.imageUrls}">
                    <div class="thumbnail question-thumb">
                        <img class="img-responsive thumbnail-zoom" src="${occurrence.imageUrls[0]}" />
                        <a href="#" class="thumbnail-zoom"><span class="fa fa-search-plus fa-2x"></span></a>
                        <div class="caption">
                            Images: ${occurrence.imageUrls.size}
                        </div>
                        <div class="sp-slides thumbnails" style="display: none;">
                            <g:each in="${occurrence.imageIds}" var="imageId" status="index">
                            <div class="sp-slide">
                                <img class="sp-image" />
                                <img class="sp-thumbnail" src="${occurrence.imageUrls[index]}" img-id="${imageId}"/>
                            </div>
                            </g:each>
                        </div>
                    </div>
                </g:if>
            </div>

            <div class="col-sm-4">
                <div class="contrib-stats">
                    <div class="cp">
                        <div class="votes">
                            <div class="contrib-number">${question.views?.size()}</div>
                            <div class="contrib-details"><a href="${questionUrl}">Views</a></div>
                        </div>
                    </div>

                    <div class="cp ${acceptedAnswer ? 'accepted' : ''}">
                        <div class="votes">
                            <div class="contrib-number">${question.answers?.size()}</div>
                            <div class="contrib-details"><a href="${questionUrl}">Answers</a></div>
                        </div>
                    </div>

                    <div class="cp">
                        <div class="votes">
                            <div class="contrib-number">${question.answers?.size() > 0 ? question.answers?.collect({it.votes?.size()}).sum() : 0}</div>
                            <div class="contrib-details"><a href="${questionUrl}">Votes</a></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</g:each>
<script>
    $(function() {
        //This has to b eexecuted every time the zone is refreshed with new content. That is why it is inside the zone
        taxonoverflow.enableTagPopovers();
    });
</script>
</aa:zone>

<g:render template="/common/imgGallery"/>
<a aa-refresh-zones="questionsListZone" id="refreshQuestionsListLink" href="#" aa-js-before="href=taxonoverflow.searchUrl" class="hidden">Refresh</a>