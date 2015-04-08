<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Help identify | Atlas of Living Australia</title>
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
                                window.location = "${createLink(action: 'delete')}/" + questionId;
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
                window.location.href = "${raw(createLink(action: 'list', params: [sort: params.sort, order: params.order, offset: 0, max: params.max]))}&q=" + encodeURIComponent(q) + "&f.tags=" + facetsFilter.tags.join(',') + "&f.types=" + facetsFilter.types.join(',');
            }

    </r:script>
    <r:require module="taxonoverflow"/>
</head>
<body>
<div class="row-fluid">
    <div class="col-md-9">
        <ul class="breadcrumb">
            <li><a class="font-xxsmall" href="http://ala.org.au">Home</a> <span class="divider"></span></li>
            <li class="active font-xxsmall">Community identification help</li>
        </ul>
    </div>

    <div class="col-md-3 text-right">
        <a href="${g.createLink(uri: '/user')}">Your activity summary</a>
    </div>
</div>

<div class="col-md-12">
    <h2 class="heading-medium">Taxonoverflow: Community identification help</h2>
</div>

<div class="row-fluid">
    <div class="col-md-12">
        <div class="panel panel-default">

            <div class="panel-body row">
                <div class="col-md-12">
                    <div class="word-limit">
                        <p class="lead">Welcome to Taxonoverflow!</p>
                        <p>On this page you will find records contributed by others that need confirmation of what they are. Help us identify these species.  Every little bit helps.</p>
                        <p>And most importantly, get involved, have fun and contribute to science.</p>
                    </div>

                    <!-- Row search -->
                    <div class="row control-group">
                        <div class="col-xs-12">
                            <form action="" method="POST" role="form">
                                <label for="txtSearch">Search for name, description or author</label>
                                <div class="input-group">
                                    <input type="text" id="txtSearch" name="txtSearch" value="${params.q}" class="form-control input-lg" placeholder="Enter name, description or author">
                                    <span class="input-group-btn">
                                        <button class="btn btn-primary btn-lg" type="button" id="btnQuestionSearch">Search</button>
                                    </span>
                                </div>
                            </form>
                            <span id="helpBlock" class="help-block">E.g. a street address, place name, postcode or GPS coordinates (as lat, long)</span>
                        </div>
                    </div><!-- End row control-group -->

                    <div class="btn-group padding-bottom-1">
                        <g:set var="sortingValues" value="${[['dateCreated', 'date'], ['viewCount', 'views'],['answerCount', 'answers']]}"/>
                        <g:each in="${sortingValues}" var="sortingValue">
                            <a class="btn btn-default ${params.sort == sortingValue[0] ? 'active' : ''}"
                               href="?sort=${sortingValue[0]}&order=${params.sort == sortingValue[0] && params.order == 'desc' ? 'asc' : 'desc'}&offset=0&q=${params.q}&f.tags=${params.f?.tags}&f.types=${params.f?.types}">
                                <i class="fa ${params.sort == sortingValue[0] && params.order == 'asc' ? 'fa-chevron-up' : 'fa-chevron-down'}"></i> <span class="hidden-xs">Sort by ${sortingValue[1]}</span>
                            </a>
                        </g:each>
                    </div>
                </div>
                <div class="col-md-10">
                    <!-- <p>Tab panel content here - tab 1</p> -->
                    <div class="comment public_comment">
                        <g:each in="${questions}" var="question" status="i">
                        <div class="comment-wrapper push">
                            <g:render template="questionListFragment"
                                      model="${[question: question, imageInfo: imageInfoMap[question.occurrenceId], acceptedAnswer: acceptedAnswers[question], occurrence: occurrenceData[question.occurrenceId]]}"/>

                        </div>
                        </g:each>
                    </div>
                </div>

                <div class="col-md-2 facets">
                    <g:include action="showAggregatedTags"/>
                    <g:include action="showAggregatedQuestionTypes"/>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
