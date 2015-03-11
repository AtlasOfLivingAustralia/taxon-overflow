<h3>Question tags</h3>
<ul id="tagsFacet">
    <g:each in="${tags}" var="tag">
        <li><span class="label ${params.f.tags.contains(tag.label) ? 'label-success' : ''} tag">${tag.label}</span> × ${tag.count}</li>
    </g:each>
</ul>