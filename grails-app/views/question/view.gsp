<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="tomain"/>
        <title>Question</title>
        <r:style type="text/css">

            #map {
                margin-left:0px;
            }

            #imageViewer {
                height: 400px;
            }

            #questionCommentsDiv {
                border-top: 1px solid #dddddd;
            }

            .occurrenceDetails {
                /*border: 1px solid #dddddd;*/
                /*border-radius: 4px;*/
                /*padding: 5px;*/
                margin-top: 10px;
            }

            .image-thumbs {
                margin-top: 10px;
                height: 125px;
            }

            .header-row {
                margin-bottom: 5px;
            }

        </r:style>
        <r:require module="viewer" />
        <r:require module="flexisel" />
        <r:require module="leaflet" />
        <r:script>

            var images = [];
            <g:each in="${occurrence.imageIds}" var="imageId">
                images.push("${imageId}");
            </g:each>

            $(document).ready(function() {

                if (images.length > 0) {
                    imgvwr.viewImage($("#imageViewer"), images[0], {})
                }

                $(".image-thumb").click(function(e) {
                    e.preventDefault();
                    var imageId = $(this).closest("[imageId]").attr("imageId");
                    if (imageId) {
                        imgvwr.viewImage($("#imageViewer"), imageId, {})
                    }
                });

                renderMap();

            });

            $(window).load(function() {

                renderAnswers();

                $("#media-thumb-list").flexisel({
                    visibleItems: 4,
                    animationSpeed: 200,
                    autoPlay: false,
                    autoPlaySpeed: 3000,
                    pauseOnHover: true,
                    clone:false,
                    enableResponsiveBreakpoints: true,
                    responsiveBreakpoints: {
                        portrait: {
                            changePoint:480,
                            visibleItems: 2
                        },
                        landscape: {
                            changePoint:640,
                            visibleItems: 3
                        },
                        tablet: {
                            changePoint:768,
                            visibleItems: 4
                        }
                    }
                });
            });

            function renderTags() {
                $.ajax("${createLink(action:'questionTagsFragment', id: question.id)}").done(function(content) {
                    $("#tagsDiv").html(content);
                });

            }

            function renderAnswers() {
                $.ajax("${createLink(action:'answersListFragment', id: question.id)}").done(function(content) {
                    $("#answersDiv").html(content);
                });
            }

            function renderQuestionComments() {
                $.ajax("${createLink(action:'questionCommentsFragment', id: question.id)}").done(function(content) {
                    $("#questionCommentsDiv").html(content);
                });
            }

            function renderMap() {
                $.ajax("${createLink(controller: 'question', action:'mapFragment', id: question.id)}").done(function(content) {
                    $("#mapDiv").html(content);
                });
            }

        </r:script>
    </head>
    <body>
        <div class="row">
            <div class="span12">
                <ul class="breadcrumb">
                    <li><a href="http://ala.org.au">Home</a> <span class="divider"><i class="fa fa-arrow-right"></i></span></li>
                    <li><g:link controller="question" action="list">Question list</g:link> <span class="divider"><i class="fa fa-arrow-right"></i></span></li>
                    <li class="active">Question X</li>
                </ul>
            </div>
        </div>

        <div class="row-fluid header-row">
            <div class="span6">
                <H1>Question ${question.id}&nbsp;<small>[ <a href="${question.source.uiBaseUrl}${question.occurrenceId}" target="occurrenceDetails">View record</a> ] Views: ${viewCount}</small></H1>

            </div>
            <div class="span6">
                <h4 class="pull-right">${answers?.size() ?: 0} ${question.questionType == au.org.ala.taxonoverflow.QuestionType.Identification ? "Identification(s)" : "Answer(s)" }</h4>
                <g:if test="${acceptedAnswer}">
                    <div class="label label-success">An identification has been accepted for this occurrence: ${acceptedAnswer.scientificName}</div>
                </g:if>
            </div>
        </div>
        <div class="row-fluid">
            <div class="span6">
                <div id="imageViewer"></div>
                <g:if test="${occurrence.imageIds?.size() > 1}">
                    <div class="image-thumbs">
                        <ul id="media-thumb-list">
                            <g:each in="${occurrence.imageIds}" var="imageId">
                                <li imageId="${occurrence.imageId}" ><img class="image-thumb" src="http://images.ala.org.au/image/proxyImageThumbnail?imageId=${imageId}" /></li>
                            </g:each>
                        </ul>
                    </div>
                </g:if>

                <g:set var="coordinates" value="${au.org.ala.taxonoverflow.OccurrenceHelper.getCoordinates(occurrence)}" />

                <g:if test="${coordinates}">
                    %{--<br/>--}%
                    <div id="mapDiv"></div>
                </g:if>

            </div>
            <div class="span6">

                <div id="tagsDiv">
                    <g:render template="tagsFragment" model="${[question: question]}" />
                </div>

                <div class="occurrenceDetails">
                    <g:render template="questionDetails" model="${[question:question, occurrence: occurrence]}" />
                </div>
                <div id="questionCommentsDiv">
                    <g:render template="questionCommentsFragment" model="${[question: question]}" />
                </div>

                <div id="answersDiv" style="margin-top:20px;">
                    <to:spinner />&nbsp;Loading answers...
                </div>
            </div>
        </div>
    </body>
</html>
