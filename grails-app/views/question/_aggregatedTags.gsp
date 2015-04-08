<h3 class="font-xxsmall">Filter by type</h3>
<ul id="tagsFacet">
    <g:each in="${tags}" var="tag">
        <g:set var="selectedTags" value="${params.f?.tags?: []}"/>
        <li><span class="label ${selectedTags.contains(tag.label) ? 'label-success' : 'label-default'} tag">${tag.label}</span> × ${tag.count}</li>
    </g:each>
</ul>