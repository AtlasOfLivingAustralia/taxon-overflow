<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main"/>
        <title>Identification case #${question.id} | Atlas of Living Australia</title>
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
                margin-top: 10px;
            }

            .image-thumbs {
                margin-top: 10px;
                height: 125px;
            }

            .header-row {
                margin-bottom: 5px;
            }
            .identify-header { padding-left:10px;  margin-top:0px; padding-top:0px; background-color: #f2f2f2; border-bottom: 1px solid #dddddd; }


        </r:style>
        <r:require modules="viewer, flexisel, leaflet, taxonoverflow" />
        <r:script>

            var GSP_VARS = {
                leafletImagesDir: "${resource(plugin: 'images-client-plugin', dir: 'js/leaflet/images')}"
            };

            var TAXON_OVERFLOW_CONF = {
                areYouSureUrl: "${createLink(controller:"dialog", action: "areYouSureFragment")}",
                pleaseWaitUrl: "${createLink(controller:'dialog', action:'pleaseWaitFragment')}"
            };

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

                $('#followQuestion i').on("mouseover", function(e) {
                    if ($(this).hasClass('fa-star-o')) {
                        $(this).removeClass('fa-star-o').addClass('fa-star')
                    } else {
                        $(this).removeClass('fa-star').addClass('fa-star-o')
                    }
                });

                $('#followQuestion i').on("mouseout", function(e) {
                    if ($(this).hasClass('fa-star') && !$(this).hasClass('following')) {
                        $(this).removeClass('fa-star').addClass('fa-star-o')
                    } else if ($(this).hasClass('fa-star-o') && $(this).hasClass('following')){
                        $(this).removeClass('fa-star-o').addClass('fa-star')
                    }
                });

                $('#followQuestion i').on('click', function() {
                    var followURL = "${g.createLink(uri: '/ws/question/follow')}/${question.id}/${to.currentUserId()}";
                    var unfollowURL = "${g.createLink(uri: '/ws/question/unfollow')}/${question.id}/${to.currentUserId()}";

                    $.ajax({
                        url: $(this).hasClass('following') ? unfollowURL : followURL,
                        dataType: "json",
                        success: function(data) {
                            //console.log(data);
                            if($("#followQuestion i").hasClass('following')) {
                                $("#followQuestion i").removeClass('fa-star following').addClass('fa-star-o');
                                $('#followingText').hide();
                                $('#unfollowingText').show();
                            } else {
                                $("#followQuestion i").removeClass('fa-star-o').addClass('fa-star following');
                                $('#followingText').show();
                                $('#unfollowingText').hide();
                            }
                        }
                    });
                }) 

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

            function checkFollowingStatus() {
                var url = "${g.createLink(uri: '/ws/question/following/status')}/${question.id}/${to.currentUserId()}";

                $.ajax({
                    url: url,
                    dataType: "json",
                    success: function(data) {
                        console.log("following: " + data.following);
                        if (data.following && !$("#followQuestion i").hasClass('following')) {
                            $("#followQuestion i").removeClass('fa-star-o').addClass('fa-star following');
                            $('#followingText').show();
                            $('#unfollowingText').hide();
                        } else if (!data.following && $("#followQuestion i").hasClass('following')) {
                            $("#followQuestion i").removeClass('fa-star following').addClass('fa-star-o');
                            $('#followingText').hide();
                            $('#unfollowingText').show();
                        }
                    }
                });
            }

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
        %{--<h1>Logged in: ${userId ? "yes" : "no" }</h1>--}%
        <div class="row">
            <div class="span12">
                <ul class="breadcrumb">
                    <li><a href="http://ala.org.au">Home</a> <span class="divider"><i class="fa fa-arrow-right"></i></span></li>
                    <li><g:link controller="question" action="list">Help identify species</g:link> <span class="divider"><i class="fa fa-arrow-right"></i></span></li>
                    <li class="active">Species identification case #${question.id}</li>
                </ul>
            </div>
        </div>

        <div class="row-fluid header-row">
            <div class="span6">
                <H1>Species identification case #${question.id}&nbsp;
                    %{--[ <a href="${question.source.uiBaseUrl}${question.occurrenceId}" target="occurrenceDetails">View record</a> ]--}%
                    <small> Views: ${viewCount}</small>
                </H1>
            </div>
            <div class="span6">
                <h4 class="pull-right">${answers?.size() ?: 0} ${question.questionType == au.org.ala.taxonoverflow.QuestionType.IDENTIFICATION ? "IDENTIFICATION(s)" : "Answer(s)" }</h4>
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
                                <li imageId="${imageId}" >
                                    <img class="image-thumb" src="http://images.ala.org.au/image/proxyImageThumbnail?imageId=${imageId}" />
                                </li>
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
                <div id="followQuestion">
                    <i class="fa ${isFollowing ? 'fa-star following' : 'fa-star-o'} fa-lg"></i>
                    <span id="followingText" style="${isFollowing ? '' : 'display:none;'}"> Following</span>
                    <span id="unfollowingText"  style="${isFollowing ? 'display:none' : ''}"> Not following</span>
                </div>

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
