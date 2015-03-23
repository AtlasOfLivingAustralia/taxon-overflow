<g:if test="${questionList}">
    %{--<ul>--}%
        <g:each in="${questionList}" var="q">
            <div style="margin-bottom: 5px;">
                <g:link controller="question" action="view" id="${q.id}"><img src="${(q.hasProperty('thumbnailUrl') && q.thumbnailUrl) ? q.thumbnailUrl.replaceAll('proxyImageThumbnailLarge','proxyImageThumbnail') : g.createLink(uri:'/images/noImage.jpg') }" alt="sighting image thumbnail" style="max-height:100px; max-width: 100px;"/> Question #${q.id}</g:link>
            </div>
        </g:each>
    %{--</ul>--}%
</g:if>
<g:else>
    <p>You have no ${questionLabel}</p>
</g:else>