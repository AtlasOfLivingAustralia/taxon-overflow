<H3 class="identify-header">Suggest an alternative identification</H3>
<div class="identify-form ">
    <div class="control-group">
        <label for="scientificName" class="control-label">Scientific Name</label>
        <div class="controls">
            <g:textField class="span8 answer-field taxon-select" name="scientificName" value="${answer?.scientificName}" />
            <g:hiddenField name="taxonConceptID" value=""/>
        </div>
    </div>
    <div class="control-group">
        <label for="identificationRemarks" class="control-label">Remarks</label>
        <div class="controls">
            <g:textArea class="span12 answer-field" name="identificationRemarks" value="${answer?.description}" />
        </div>
    </div>
</div>
