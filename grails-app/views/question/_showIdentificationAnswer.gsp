<%@ page import="groovy.json.JsonSlurper" %>
<style>
    .scientificName {
        font-style: italic;
    }
</style>
<g:set var="answerProperties" value="${new groovy.json.JsonSlurper().parseText(answer.darwinCore)}"/>
<div class="identificationScientificName answer-main">
    <g:if test="${answerProperties.taxonConceptID}">
        <a href="http://bie.ala.org.au/species/${answerProperties.taxonConceptID}">
    </g:if>
    <span class="scientificName">${answerProperties.scientificName}</span>
    <g:if test="${answerProperties.commonName && answerProperties.scientificName}">
        <span class="sciCommonSep"> : </span>
    </g:if>
    <span class="commonName">${answerProperties.commonName}</span>
    <g:if test="${answerProperties.taxonConceptID}">
        </a>
    </g:if>
</a>

</div>
<div class="identificationRemarks answer-description">
    ${answer.description}
</div>