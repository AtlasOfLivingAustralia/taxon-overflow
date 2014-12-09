<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="tomain"/>
        <title>Welcome to Grails</title>

        <style>
        <r:style type="text/css">

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

            .occurrence-property-value {
                font-weight: bold;
            }

            .image-thumbs {
                margin-top: 10px;
                height: 125px;
            }

            .header-row {
                margin-bottom: 5px;
            }

        </r:style>
        </style>


        <r:require module="viewer" />
        <r:require module="flexisel" />

        <r:script>

            var images = [];
            <g:each in="${imageIds}" var="imageId">
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

        </r:script>

    </head>
    <body class="content">

        <div class="row-fluid header-row">
            <div class="span6">
                <H3>Question ${question.id}&nbsp;<small>[ <a href="http://biocache.ala.org.au/occurrence/${question.occurrenceId}" target="occurrenceDetails">View record in biocache</a> ] Views: ${viewCount}</small></H3>
                <div id="tagsDiv">
                    <g:render template="tagsFragment" model="${[question: question]}" />
                </div>
            </div>
            <div class="span6">
                <h4>${answers?.size() ?: 0} ${question.questionType == au.org.ala.taxonoverflow.QuestionType.Identification ? "Identification(s)" : "Answer(s)" }</h4>
                <g:if test="${acceptedAnswer}">
                    <div class="label label-success">An identification has been accepted for this occurrence: ${acceptedAnswer.scientificName}</div>
                </g:if>
            </div>
        </div>

        <div class="row-fluid">
            <div class="span6">
                <div id="imageViewer"></div>
                <g:if test="${imageIds?.size() > 1}">
                    <div class="image-thumbs">
                        <ul id="media-thumb-list">
                            <g:each in="${imageIds}" var="imageId">
                                <li imageId="${imageId}" ><img class="image-thumb" src="http://images.ala.org.au/image/proxyImageThumbnail?imageId=${imageId}" /></li>
                            </g:each>
                        </ul>
                    </div>
                </g:if>
                <div class="occurrenceDetails">
                    <g:render template="questionDetails" model="${[question:question, occurrence: occurrence]}" />
                </div>
                <div id="questionCommentsDiv">
                    <g:render template="questionCommentsFragment" model="${[question: question]}" />
                </div>
            </div>
            <div class="span6">
                <div id="answersDiv">
                    <to:spinner />&nbsp;Loading answers...
                </div>
            </div>
        </div>
    </body>
</html>
