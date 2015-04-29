<g:set var="answerProperties" value="${answer? new groovy.json.JsonSlurper().parseText(answer.darwinCore) : [:]}"/>
<div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
    <h4 class="modal-title" id="myModalLabel">${answer ? 'Edit' : 'Add'} a geospatial location</h4>
</div>
<div class="modal-body">
    <div class="alert alert-danger" role="alert" style="display: none;">
        <span class="alertText"></span>
    </div>
    <div class="form-group">
        <label for="decimalLatitude" class="col-sm-4 control-label">Latitude (decimal degrees)</label>
        <div class="col-sm-7">
            <g:textField class="form-control" name="decimalLatitude" value="${answerProperties?.decimalLatitude}" placeholder="Enter a decimal latitude number"/>
        </div>
    </div>
    <div class="form-group">
        <label for="decimalLongitude" class="col-sm-4 control-label">Longitude (decimal degrees)</label>
        <div class="col-sm-7">
            <g:textField class="form-control" name="decimalLongitude" value="${answerProperties?.decimalLongitude}" placeholder="Enter a decimal longitude number"/>
        </div>
    </div>
    <div class="form-group">
        <label for="description" class="col-sm-4 control-label">Comments or remarks</label>
        <div class="col-sm-7">
            <g:textArea class="form-control" name="description" placeholder="Enter your comments or remarks" rows="4">${answerProperties?.description}</g:textArea>
        </div>
    </div>
</div>
<div class="modal-footer">
    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
    <button type="button" class="btn btn-primary" id="submitAnswerButton">${answer ? 'Edit' : 'Add'} location</button>
</div>