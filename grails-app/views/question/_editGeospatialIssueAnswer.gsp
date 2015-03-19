<H3 class="identify-header">Suggest a correct to the geospatial coordinates</H3>
<g:set var="answerProperties" value="${new groovy.json.JsonSlurper().parseText(answer.darwinCore)}"/>
<div class="identify-form ">
    <div class="control-group">
        <label for="decimalLatitude" class="control-label">Latitude (decimal degrees)</label>
        <div class="controls">
            <g:textField class="span8 answer-field" name="decimalLatitude" value="${answerProperties?.decimalLatitude}" />
        </div>
        <label for="decimalLongitude" class="control-label">Longitude (decimal degrees)</label>
        <div class="controls">
            <g:textField class="span8 answer-field" name="decimalLongitude" value="${answerProperties?.decimalLongitude}" />
        </div>
    </div>
    <div class="control-group">
        <label for="description" class="control-label">Remarks</label>
        <div class="controls">
            <g:textArea class="span12 answer-field" name="description" value="${answer?.description}" />
        </div>
    </div>
</div>
