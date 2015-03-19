<H3 class="identify-header">Suggest a correction to the geospatial coordinates</H3>
<g:set var="answerProperties" value="${new groovy.json.JsonSlurper().parseText(answer.darwinCore)}"/>
<div class="identify-form ">
    <div class="control-group">
        <label for="description" class="control-label">Remarks</label>
        <div class="controls">
            <g:textArea class="span12 answer-field" name="description" value="${answer?.description}" />
        </div>
    </div>
</div>
