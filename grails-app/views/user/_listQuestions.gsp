<g:if test="${questionList}">
    %{--<ul>--}%
        <g:each in="${questionList}" var="q">
            <div style="margin-bottom: 5px;">
                <g:set var="defaultUrl" value="${(q.hasProperty('imageUrls') && q.imageUrls.get(0)) ? q.imageUrls.get(0).replaceAll('proxyImageThumbnailLarge','proxyImageThumbnail') : g.createLink(uri:'/images/noImage.jpg') }"/>
                <g:set var="imageId" value="${(q.hasProperty('imageIds') && q.imageIds) ? q.imageIds.get(0) : '' }"/>
                <g:link controller="question" action="view" id="${q.id}"><img src="${to.getImageUrlForImageId(imageId: imageId, fallbackUrl: defaultUrl, imageFormat: 'thumbnail_square')}" alt="sighting image thumbnail" style="max-height:100px; max-width: 100px;"/> Question #${q.id}</g:link>
            </div>
        </g:each>
    %{--</ul>--}%
</g:if>
<g:else>
    <p>You have no ${questionLabel}</p>
</g:else>