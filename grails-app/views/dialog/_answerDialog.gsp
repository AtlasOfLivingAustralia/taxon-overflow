<g:form name="answerForm" controller="webService" action="${answer ? 'updateAnswer' : 'submitAnswer'}" class="form-horizontal">
    <g:set var="answerProperties" value="${answer? new groovy.json.JsonSlurper().parseText(answer.darwinCore) : [:]}"/>
    <g:hiddenField name="questionId" value="${question.id}"/>
    <g:hiddenField name="answerId" value="${answer?.id}"/>
    <g:hiddenField name="userId" value="${to.currentUserId()}"/>
    <div class="modal fade" id="answerModalDialog" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">${answer ? 'Edit' : 'Add'} an Identification</h4>
                </div>
                <div class="modal-body">
                    <div class="alert alert-danger" role="alert" style="display: none;">
                        <span class="alertText"></span>
                    </div>
                    <div class="form-group">
                        <label for="scientificName" class="col-sm-3 control-label">Scientific name</label>
                        <div class="col-sm-8">
                            <g:textField class="form-control taxon-select taxon-select-scientific" name="scientificName" value="${answerProperties?.scientificName}" placeholder="Enter a scientific name"/>
                            <g:hiddenField class="answer-field taxon-select-guid" name="taxonConceptID" value="${answerProperties?.taxonConceptID}"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="commonName" class="col-sm-3 control-label">Common name</label>
                        <div class="col-sm-8">
                            <g:textField class="form-control taxon-select-common" name="commonName" value="${answerProperties?.commonName}" placeholder="Enter a common name"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="taxonConceptID" class="col-sm-3 control-label">Comments or remarks</label>
                        <div class="col-sm-8">
                            <g:textArea class="form-control" name="description" placeholder="Enter your comments or remarks" rows="4">${answerProperties?.description}</g:textArea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" id="submitAnswerButton">${answer ? 'Edit' : 'Add'} identification</button>
                </div>
            </div>
        </div>
    </div>
</g:form>
<script>
    $('#answerModalDialog').on('shown.bs.modal', function () {
        $("#scientificName").focus();
    });

    $('#answerForm input').on('keypress', function(e){
        if (e.which == 13) {
            e.preventDefault();
            $('#submitAnswerButton').click();
        }
    });

    $('#submitAnswerButton').on('click', function(e) {
        e.preventDefault();
        var response = tolib.doAjaxRequest($("#answerForm").attr('action'), tolib.serializeFormJSON($("#answerForm")));
        response.done(function(data) {
            if (data.success) {
                $("#answerModalDialog").modal('hide');
                $("#refreshAnswersLink").click();
            } else {
                $("#answerForm .alertText").text(data.message);
                $("#answerForm .alert").show();
            }
        });
    });


    $(".taxon-select").autocomplete('http://bie.ala.org.au/ws/search/auto.jsonp', {
        extraParams: {limit: 10},
        dataType: 'jsonp',
        parse: function (data) {
//            console.log("parsing")
            var rows = new Array();
            data = data.autoCompleteList;
            for (var i = 0; i < data.length; i++) {
                rows[i] = {
                    data: data[i],
                    value: data[i].matchedNames[0],
                    result: data[i].matchedNames[0]
                };
            }
            return rows;
        },
        select: function (event, ui) {
            alert("Selected: " + ui.item.value + " aka " + ui.item.label);
//            console.log('selected ' + ui.item.value);
            $(this).val(ui.item.label);
            return false;
        },
        matchSubset: false,
        formatItem: function (row, i, n) {
//            console.log("formatItem");
            return row.matchedNames[0];
        },
        cacheLength: 10,
        minChars: 3,
        scroll: false,
        max: 10
    }).result(function(event, item) {
        // user has selected an autocomplete item
//        console.log("item", item);
        $('.taxon-select-guid').val(item.guid);
        $('.taxon-select-scientific').val(item.name);
        $('.taxon-select-common').val(item.commonName);
    }).on('change', function () {
        //TODO select the taxon...
    }).keydown(function (event) {
        if (event.keyCode == 13) {
            //TODO select the taxon...
        }
    });
</script>