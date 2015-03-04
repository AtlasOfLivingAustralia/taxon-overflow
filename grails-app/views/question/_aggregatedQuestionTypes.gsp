<h3>Question Type</h3>
<ul>
    <g:each in="${questionTypes}" var="questionType">
        <li><span class="label tag">${questionType.label}</span> × ${questionType.count}</li>
    </g:each>
</ul>