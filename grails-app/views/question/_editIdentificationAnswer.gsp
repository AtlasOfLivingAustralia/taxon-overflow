<H3 class="identify-header">Identify this occurrence</H3>
<g:set var="answerProperties" value="${answer ? new groovy.json.JsonSlurper().parseText(answer.darwinCore) : [:]}"/>
<div class="identify-form ">
    <div class="control-group">
        <label for="scientificName" class="control-label">Scientific name</label>
        <div class="controls">
            <g:textField class="span8 answer-field  taxon-select taxon-select-scientific" name="scientificName" value="${answerProperties?.scientificName}" />
        </div>
        <label for="commonName" class="control-label">Common name</label>
        <div class="controls">
            <g:textField class="span8 answer-field taxon-select-common" name="commonName" value="${answerProperties?.commonName}" />
        </div>
        <div class="controls hide">
            <g:textField class="answer-field taxon-select-guid" name="taxonConceptID" value="${answerProperties?.taxonConceptID}"/>
        </div>
    </div>
    <div class="control-group">
        <label for="description" class="control-label">Remarks</label>
        <div class="controls">
            <g:textArea class="span12 answer-field" name="description" value="${answer?.description}" />
        </div>
    </div>
</div>
