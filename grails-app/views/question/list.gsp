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
                padding-top: 4px;
                padding-bottom: 4px;
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

            .facets ul { list-style: none; margin-left:0;}

        </r:style>
        </style>
        <r:script>

            var facetsFilter = {
                tags: [],
                types: []
            }

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

                $("div.facets ul li span.label").on("click", function() {
                    $(this).toggleClass('label-success');
                    updateFacetsFilter();
                });

            });

            function updateFacetsFilter() {
                facetsFilter.tags = [];
                facetsFilter.types = [];
                $("#tagsFacet li span.label-success").each(function() {
                    facetsFilter.tags.push($(this).text());
                });
                $("#typesFacet li span.label-success").each(function() {
                    facetsFilter.types.push($(this).text());
                });
                doSearch();
            }

            function doSearch() {
                var q = $("#txtSearch").val();
                window.location.href = "${raw(createLink(action:'list', params: [sort: params.sort, order: params.order, offset: 0, max: params.max]))}&q=" + encodeURIComponent(q) + "&f.tags=" + facetsFilter.tags.join(',') + "&f.types=" + facetsFilter.types.join(',');
            }

        </r:script>
    </head>
    <body>
        <div class="row">
            <div class="span12">
                <ul class="breadcrumb">
                    <li><a href="http://ala.org.au">Home</a> <span class="divider"><i class="fa fa-arrow-right"></i></span></li>
                    <li class="active">Help identify species</li>
                </ul>
            </div>
        </div>
        <h1>Help identify species</h1>
        <p class="lead">
            Here are the latest records needing identification help from the community.
            <br/>
            <strong>Get involved</strong> by suggesting an identification.
        </p>
        <div class="taxonoverflow-content row-fluid">
            <div class="span3 facets">
                <g:include action="showAggregatedTags"/>
                <g:include action="showAggregatedQuestionTypes"/>
            </div>
            <div class="span9">
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
                                        <div style="text-align: center" class="${columnDesc[2]} column-sort-btn"><a href="?sort=${columnDesc[0]}&order=${params.sort == columnDesc[0] && params.order != 'desc' ? 'desc' : 'asc'}&offset=0&q=${params.q}&f.tags=${params.f?.tags}&f.types=${params.f?.types}" class="btn ${params.sort == columnDesc[0] ? 'active' : ''}">${columnDesc[1]}</a></div>
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
