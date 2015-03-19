<%@ page import="groovy.json.JsonSlurper" %>
<style>
    .scientificName {
        font-style: italic;
    }
</style>
<g:set var="answerProperties" value="${new groovy.json.JsonSlurper().parseText(answer.darwinCore)}"/>
<div class="identificationScientificName answer-main">
    <span class="scientificName">${answerProperties.scientificName}</span>
</div>
<div class="identificationRemarks answer-description">
    ${answer.description}
</div>