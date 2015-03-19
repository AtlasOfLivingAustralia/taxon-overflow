<H3 class="identify-header">Identify this occurrence</H3>
<g:set var="answerProperties" value="${new groovy.json.JsonSlurper().parseText(answer.darwinCore)}"/>
<div class="identify-form ">
    <div class="control-group">
        <label for="scientificName" class="control-label">Scientific Name</label>
        <div class="controls">
            <g:textField class="span8 answer-field taxon-select" name="scientificName" value="${answerProperties?.scientificName}" />
            <g:hiddenField name="taxonConceptID" value=""/>
        </div>
    </div>
    <div class="control-group">
        <label for="description" class="control-label">Remarks</label>
        <div class="controls">
            <g:textArea class="span12 answer-field" name="description" value="${answer?.description}" />
        </div>
    </div>
</div>
