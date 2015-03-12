<h3>Question tags</h3>
<ul id="tagsFacet">
    <g:each in="${tags}" var="tag">
        <g:set var="selectedTags" value="${params.f?.tags?: []}"/>
        <li><span class="label ${selectedTags.contains(tag.label) ? 'label-success' : ''} tag">${tag.label}</span> × ${tag.count}</li>
    </g:each>
</ul>