<style>
body {
    font-family: Arial,sans-serif;
    color: #637073;
    font-size: 14px;
}
</style>
<g:set var="questionNumber" value="${questionTag.questionId}"/>
<p>The tag "${questionTag.tag}" was added for <a href="${grailsApplication.config.grails.serverURL}/question/view/${questionNumber}">question #${questionNumber} on Taxon-Overflow</a></p>