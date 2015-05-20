<%@ page import="au.org.ala.taxonoverflow.QuestionType" %>
<style>
body {
    font-family: Arial,sans-serif;
    color: #637073;
    font-size: 14px;
}
</style>
<g:set var="questionNumber" value="${answer.questionId}"/>
<p>An answer for <a href="${grailsApplication.config.grails.serverURL}/question/view/${questionNumber}">question #${questionNumber}</a> at the ALA "Community Identification Help" tool has been ${answer.accepted ? 'accepted' : 'posted'}.</p>
<g:if test="${answer.accepted && answer.question.questionType == QuestionType.IDENTIFICATION}">
    <g:set var="answerProperties" value="${new groovy.json.JsonSlurper().parseText(answer.darwinCore)}"/>
    <p>The sighting has been identified as: <strong>${answerProperties.commonName && answerProperties.scientificName ? "${answerProperties.scientificName} : ${answerProperties.commonName}" : "${answerProperties.scientificName}"}</p></strong>
</g:if>