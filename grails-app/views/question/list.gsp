<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="tomain"/>
        <title>Help identify | Atlas of Living Australia</title>
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
        <h1>Latest questions</h1>
        <p class="lead">
            Here are the latest record needing identification help from the community.
            Get involved by suggesting an identification.
        </p>

        <div class="taxonoverflow-content row-fluid">
            <div class="span2">
                <h3>Question tags</h3>
                <ul>
                    <li><span class="label tag">Birds</span> × 3222</li>
                    <li><span class="label tag">Lizards</span> × 3123</li>
                    <li><span class="label tag">Insects</span> × 322</li>
                    <li><span class="label tag">Reptiles</span> × 44</li>
                    <li><span class="label tag">Plants</span> × 44</li>
                    <li><span class="label tag">NSW</span> × 22</li>
                    <li><span class="label tag">ACT</span> × 22</li>
                    <li><span class="label tag">QLD</span> × 22</li>
                </ul>
            </div>
            <div class="span10">
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
                                        <g:render template="questionListFragment" model="${[question: question, imageInfo: imageInfoMap[question.occurrenceId], acceptedAnswer: acceptedAnswers[question], occurrence: occurrenceData[question.occurrenceId]]}" />
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
        </div>
    </body>
</html>
