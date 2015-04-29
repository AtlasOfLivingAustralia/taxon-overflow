<%@ page import="au.org.ala.taxonoverflow.QuestionType" %>
<g:form name="answerForm" controller="webService" action="${answer ? 'updateAnswer' : 'submitAnswer'}" class="form-horizontal">
    <g:hiddenField name="questionId" value="${question.id}"/>
    <g:hiddenField name="answerId" value="${answer?.id}"/>
    <g:hiddenField name="userId" value="${to.currentUserId()}"/>
    <div class="modal fade" id="answerModalDialog" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <g:set var="questionTypeTemplate" value="${[
                        (QuestionType.IDENTIFICATION): 'questionType/identificationIssue',
                        (QuestionType.GEOCODING_ISSUE): 'questionType/geospatialIssue'
                ]}"/>
                <g:render template="${questionTypeTemplate[question.questionType]}" model="${[answer: answer]}"/>
            </div>
        </div>
    </div>
</g:form>
<script>
    $('#answerModalDialog').on('shown.bs.modal', function () {
        console.log($("#answerForm input.form-control:first-child").attr('id'));
        $("#answerForm input.form-control:first-child")[0].focus();
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