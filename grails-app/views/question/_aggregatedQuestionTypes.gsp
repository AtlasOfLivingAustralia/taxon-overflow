<h3 class="font-xxsmall">Filter by question</h3>
<ul id="typesFacet">
    <g:each in="${questionTypes}" var="questionType">
        <g:set var="selectedTypes" value="${params.f?.types?: []}"/>
        <li><span class="label ${selectedTypes.contains(questionType.label) ? 'label-success' : 'label-default'} tag">${questionType.label}</span> × ${questionType.count}</li>
    </g:each>
</ul>