<style>
body {
    font-family: Arial,sans-serif;
    color: #637073;
    font-size: 14px;
}
</style>
<g:set var="questionNumber" value="${answer.questionId}"/>
<p>${userDetails.displayName} ${answer.accepted ? 'accepted' : 'posted'} an identification answer for <a href="${grailsApplication.config.grails.serverURL}/question/view/${questionNumber}">question #${questionNumber} on Taxon-Overflow</a></p>