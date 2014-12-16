<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="tomain"/>
        <title>Welcome to Grails</title>
        <style>
        <r:style>

            .question-thumb {
                height: 100px;
                max-height: 100px;
            }

            .question-list > thead {
                background-color: #F0F0E8;
            }

            .question-list .accepted-answer-mark {
                font-size: 3em;
                color: green;
                border: 1px solid transparent;
            }

            .question-view-count, .question-answer-count {
                font-size: 1.5em;
                padding-right: 10px;
                padding-left: 10px;
            }

            .question-answer-count.has-accepted-answer {
                color: white;
                background-color: darkolivegreen;
            }

            .answer-count-div, .view-count-div {
                text-align: center;
            }

            .view-count-div {
                color: #888888;
            }

            .question-meta-panel a, .question-meta-panel a:hover {
                text-decoration: none;
            }

            .accepted-answer-text {
                font-style: italic;
            }

        </r:style>
        </style>
        <r:script>

            $(document).ready(function() {

                $(".btnDelete").click(function(e) {
                    e.preventDefault();
                    var questionId = $(this).closest("[questionId]").attr("questionId");
                    if (questionId) {
                        tolib.areYouSure({
                            title: "Delete question", message: "Are you sure you wish to delete this question?",
                            affirmativeAction: function() {
                                window.location = "${createLink(action:'delete')}/" + questionId;
                            }
                        })
                    }
                });

                $("#btnQuestionSearch").click(function(e) {
                    e.preventDefault();
                    doSearch();
                });

                $("#txtSearch").keydown(function(e) {
                    if (e.keyCode == 13) {
                        doSearch();
                    }
                });

            });

            function doSearch() {
                var q = $("#txtSearch").val();
                window.location.href = "${raw(createLink(action:'list', params: [sort: params.sort, order: params.order, offset: 0, max: params.max]))}&q=" + encodeURIComponent(q);
            }

        </r:script>

    </head>
    <body>
        <div class="content">
            <table class="table table-bordered table-condensed question-list">
                <thead>
                    <tr>
                        <td>
                            <g:set var="questionCount" value="${totalCount}" />
                            ${questionCount} ${questionCount == 1 ? 'question' : 'questions'}
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="row-fluid">
                                <g:set var="columns" value="${[ ['answerCount', 'Answers', 'span1'], ['viewCount', 'Views','span1'], ['dateCreated', 'Date', 'span2'] ] }" />
                                <g:each in="${columns}" var="columnDesc">
                                    <div style="text-align: center" class="${columnDesc[2]} column-sort-btn"><a href="?sort=${columnDesc[0]}&order=${params.sort == columnDesc[0] && params.order != 'desc' ? 'desc' : 'asc'}&offset=0&q=${params.q}" class="btn ${params.sort == columnDesc[0] ? 'active' : ''}">${columnDesc[1]}</a></div>
                                </g:each>
                                <div class="span6 offset2">
                                    <div class="pull-right">
                                        <div class="form-horizontal">
                                            <g:textField name="txtSearch" value="${params.q}" />
                                            <button type="button" id="btnQuestionSearch" class="btn"><i class="fa fa-search"></i>&nbsp;Search</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </td>
                    </tr>
                </thead>
                <tbody>
                    <g:each in="${questions}" var="question" status="i">
                        <tr questionId="${question.id}">
                            <td>
                                <div class="question-container">
                                    <g:render template="questionListFragment" model="${[question: question, imageInfo: imageInfoMap[question.occurrenceId]?.get(0), acceptedAnswer: acceptedAnswers[question], occurrence: occurrenceData[question.occurrenceId]]}" />
                                </div>
                            </td>
                        </tr>
                    </g:each>
                </tbody>
            </table>
            <div class="pagination">
                <g:paginate total="${totalCount}" />
            </div>
        </div>
    </body>
</html>
