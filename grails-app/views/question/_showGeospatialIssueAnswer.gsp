<%@ page import="groovy.json.JsonSlurper" %>
<g:set var="answerProperties" value="${new groovy.json.JsonSlurper().parseText(answer.darwinCore)}"/>
<div class="coordinates answer-main">
    <span class="decimalLatitude">${answerProperties.decimalLatitude}</span>
    <span class="decimalLatitude">${answerProperties.decimalLongitude}</span>
</div>
<div class="geospatialRemarks answer-description">
    ${answer.description}
</div>