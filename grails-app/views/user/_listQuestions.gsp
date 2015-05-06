<div class="summary-thumbnails">
    <g:if test="${questionList}">
        <g:each in="${questionList}" var="q">
            <div class="col-sm-3">
                <g:set var="defaultUrl" value="${(q.hasProperty('imageUrls') && q.imageUrls?.size() > 0) ? q.imageUrls?.get(0).replaceAll('proxyImageThumbnailLarge','proxyImageThumbnail') : g.createLink(uri:'/images/noImage.jpg') }"/>
                <g:set var="imageId" value="${(q.hasProperty('imageIds') && q.imageIds?.size() > 0) ? q.imageIds?.get(0) : '' }"/>
                <g:link controller="question" action="view" id="${q.id}" class="thumbnail">
                    <img src="${to.getImageUrlForImageId(imageId: imageId, fallbackUrl: defaultUrl, imageFormat: 'thumbnail_square')}" alt="sighting image thumbnail"/>
                    <div class="caption">
                        Question #${q.id}
                    </div>
                </g:link>
            </div>
        </g:each>
    </g:if>
    <g:else>
        <p>You have no ${questionLabel}</p>
    </g:else>
</div>