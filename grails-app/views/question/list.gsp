<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="to-main"/>
    <title>Help identify | Atlas of Living Australia</title>
    <r:script>
        $(function() {
            var q = $("#txtSearch").val();
            var searchUrl = "${raw(createLink(action: 'list', params: [sort: params.sort, order: params.order, offset: 0, max: params.max]))}&q=" + encodeURIComponent(q);
            taxonoverflow.init({searchUrl: searchUrl});
        });
    </r:script>
    <r:require module="taxonoverflow-list"/>
</head>
<body>

<div class="row-fluid">
    <div class="col-sm-9">
        <ul class="breadcrumb">
            <li><a class="font-xxsmall" href="http://ala.org.au">Home</a> <span class="divider"></span></li>
            <li class="active font-xxsmall">Community identification help</li>
        </ul>
    </div>

    <g:render template="activitySummary"/>
</div>

<div class="row-fluid">
    <div class="col-md-12">
        <h2 class="heading-medium">Community identification help<sup class="beta-badge">&nbsp;beta</sup></h2>
    </div>
</div>

<div class="row-fluid">
    <div class="col-md-12">
        <div class="panel panel-default">
            <div class="panel-heading question-heading">
                <h3 class="heading-underlined">Welcome to the Community identification help page!</h3>
            </div>
            <div class="panel-body row">
                <div class="col-md-12">
                    <div id="infoAlert1" class="alert alert-info alert-dismissible" role="alert">
                        <button info-alert="infoAlert1" type="button" class="close info-alert-close-btn" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        On this page you will find records contributed by others that need confirmation of what they are. Help us identify these species. Every little bit helps.
                        And most importantly, get involved, have fun and contribute to science.
                    </div>

                    <!-- Row search -->
                    <div class="row control-group">
                        <div class="col-xs-12">
                            <label for="txtSearch">Search for name, description or author</label>
                            <div class="input-group">
                                <input type="text" id="txtSearch" name="txtSearch" value="${params.q}" class="form-control input-lg" placeholder="Enter name, description or author">
                                <span class="input-group-btn">
                                    <button class="btn btn-primary btn-lg" type="button" id="btnQuestionSearch">Search</button>
                                </span>
                            </div>
                            <span id="helpBlock" class="help-block">E.g. a street address, place name, postcode or GPS coordinates (as lat, long)</span>
                        </div>
                    </div><!-- End row control-group -->

                    <div class="btn-group padding-bottom-1 sorting-buttons">
                        <g:set var="sortingValues" value="${[['dateCreated', 'date'], ['viewCount', 'views'],['answerCount', 'answers']]}"/>
                        <g:each in="${sortingValues}" var="sortingValue">
                            <a class="btn btn-default ${params.sort == sortingValue[0] ? 'active' : ''}"
                               href="?sort=${sortingValue[0]}&order=${params.sort == sortingValue[0] && params.order == 'desc' ? 'asc' : 'desc'}&offset=0&q=${params.q}&f.tags=${params.f?.tags}&f.types=${params.f?.types}">
                                <i class="fa ${params.sort == sortingValue[0] && params.order == 'asc' ? 'fa-chevron-up' : 'fa-chevron-down'}"></i> <span>Sort by ${sortingValue[1]}</span>
                            </a>
                        </g:each>
                    </div>
                </div>
                <div class="col-md-10">
                    <!-- <p>Tab panel content here - tab 1</p> -->
                    <div class="comment public_comment">
                        <g:render template="questionsList"
                                  model="${[questions: questions, acceptedAnswers: acceptedAnswers, occurrenceData: occurrenceData, tagsFollowing: tagsFollowing, imagesServiceBaseUrl: imagesServiceBaseUrl]}"/>
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

<g:if test="${totalCount > au.org.ala.taxonoverflow.QuestionController.defaultPageSize}">
<div class="row-fluid">
    <nav class="col-sm-12 text-center">
    <g:paginate total="${totalCount}" class="pagination-lg"/>
    </nav>
</div>
</g:if>

<a aa-refresh-zones="aggregatedTagsZone" id="refreshAggregatedTagsLink" href="${g.createLink(action: 'showAggregatedTags')}" class="hidden">Refresh</a>

</body>
</html>
