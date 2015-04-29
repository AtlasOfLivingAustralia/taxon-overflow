<form class="form-horizontal">
    <div class="form-group">
        <label for="latitude" class="col-sm-4 control-label">Latitude</label>
        <div class="col-sm-8">
            <span id="latitude" class="form-control">${answerProperties.decimalLatitude}</span>
        </div>
    </div>
    <div class="form-group">
        <label for="longitude" class="col-sm-4 control-label">Longitude</label>
        <div class="col-sm-8">
            <span id="longitude" class="form-control">${answerProperties.decimalLongitude}</span>
        </div>
    </div>
    <g:if test="${answerProperties.description}">
        <p class="font-xsmall">${answerProperties.description}</p>
    </g:if>
</form>