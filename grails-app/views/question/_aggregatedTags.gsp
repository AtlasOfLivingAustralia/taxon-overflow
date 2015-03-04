<h3>Question tags</h3>
<ul>
    <g:each in="${tags}" var="tag">
        <li><span class="label tag">${tag.label}</span> × ${tag.count}</li>
    </g:each>
</ul>