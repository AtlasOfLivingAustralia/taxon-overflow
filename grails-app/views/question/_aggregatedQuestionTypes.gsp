<h3>Question Type</h3>
<ul id="typesFacet">
    <g:each in="${questionTypes}" var="questionType">
        <li><span class="label ${params.f.types.contains(questionType.label) ? 'label-success' : ''} tag">${questionType.label}</span> × ${questionType.count}</li>
    </g:each>
</ul>