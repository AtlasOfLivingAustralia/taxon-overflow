<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Case #${question.id} | Community identification help | Atlas of Living Australia</title>
    <r:require modules="taxonoverflow, viewer, flexisel, leaflet, ajaxanywhere, bootbox" />
</head>
<body>

<div class="row-fluid">
    <div class="col-md-9">
        <ol class="breadcrumb">
            <li><a class="font-xxsmall" href="http://ala.org.au">Home</a></li>
            <li><a class="font-xxsmall" href="${g.createLink(controller:"question", action:"list")}">Community identification help</a></li>
            <li class="font-xxsmall active">Species identification case #${question.id}</li>
        </ol>
    </div>

    <div class="col-md-3 text-right">
        <a class="btn btn-primary" href="${g.createLink(uri: '/user')}">Your activity summary</a>
    </div>
</div>

<div class="col-md-12">
    <h2 class="heading-medium">
        Species identification case #${question.id}
        <g:if test="${grailsApplication.config.testUsers}">
            <ul class="nav nav-pills pull-right" id="userSwitch">
                <li class="dropdown">
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                        Logged in: ${to.currentUserDisplayName()}, Switch users
                        <b class="caret"></b>
                    </a>
                    <ul class="dropdown-menu">
                        <g:each in="${grailsApplication.config.testUsers.split(',')}" var="testUser">
                            <li>
                                <to:switchUserLink email="${testUser}"/>
                            </li>
                        </g:each>
                    </ul>
                </li>
            </ul>
        </g:if>
    </h2>
</div>

<!-- Panel content -->
<div class="row-fluid">
    <div class="col-md-12">
        <div class="panel panel-default">
            <div class="panel-heading question-heading">
                <h3 class="heading-underlined">Information Overview</h3>
            </div>

            <div class="panel-body row">
                <div class="col-md-6">
                    <!-- <h3 class="heading-medium">Content</h3> -->
                    <p>Please provide an identification for this observation, or agree, disagree or comment on identifications provided by other users.</p>
                    <div class="btn-group padding-bottom-1">
                        <a class="btn btn-default active togglePlaceholder" title="Show Image" href="#"><i class="fa fa-picture-o"></i> <span class="hidden-xs">Toggle image</span></a>
                        <a class="btn btn-default togglePlaceholder" title="Show Map" href="#"><i class="fa fa-map-marker"></i> <span class="hidden-xs">Toggle map</span></a>

                    </div>

                    <aa:zone id="followingZone">
                        <g:include action="followingFragment" id="${question.id}"/>
                    </aa:zone>

                    <g:set var="coordinates" value="${au.org.ala.taxonoverflow.OccurrenceHelper.getCoordinates(occurrence)}" />
                    <g:if test="${occurrence.imageIds || coordinates}">
                        <div id="imagePlaceHolder" class="placeholder">
                            <g:if test="${occurrence.imageIds}">
                                <div id="imageViewer" class="img-responsive"></div>
                            </g:if>
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
                        </div>
                        <g:if test="${coordinates}">
                        <div id="map" class="placeholder img-responsive hidden">
                            <aa:zone id="mapzone" fragmentUrl="${g.createLink(action: 'mapFragment', id: question.id)}"></aa:zone>
                        </div>
                        </g:if>
                    </g:if>

                    <aa:zone id="tagsZone">
                        <g:render template="tagsFragment" model="${[question: question]}" />
                    </aa:zone>

                    <g:render template="questionDetails" model="${[question:question, occurrence: occurrence]}" />

                </div>
                <div class="col-xs-12 col-sm-7 col-md-6">

                    <!-- Tab navigation -->
                    <ul class="nav nav-tabs">
                        <li class="font-xxsmall ${question.answers ? 'active' : ''}"><a href="#answersPane" data-toggle="tab">Answers</a></li>
                        <li class="font-xxsmall ${!question.answers ? 'active' : ''}"><a href="#commentsPane" data-toggle="tab">Comments</a></li>
                    </ul>

                    <!-- Tab sections -->
                    <div class="tab-content">
                        <div class="tab-pane ${question.answers ? 'active' : ''}" id="answersPane">
                            <g:include action="answers" id="${question.id}"/>
                        </div>

                        <div class="tab-pane ${!question.answers ? 'active' : ''}" id="commentsPane">
                            <g:include action="questionComments" id="${question.id}"/>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<r:script>
        var GSP_VARS = {
            leafletImagesDir: "${resource(plugin: 'images-client-plugin', dir: 'js/leaflet/images')}"
        };

        var images = [];
    <g:each in="${occurrence.imageIds}" var="imageId">
        images.push("${imageId}");
    </g:each>

    $(document).ready(function() {

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

        if (images.length > 0) {
            imgvwr.viewImage($("#imageViewer"), images[0], {})
        }

        $(document).on('click', '#followQuestionButton', function() {
            $(this).find('i').removeClass('fa-star fa-star-o').addClass('fa-cog fa-spin')
            var followURL = "${g.createLink(uri: '/ws/question/follow')}/${question.id}/${to.currentUserId()}";
            var unfollowURL = "${g.createLink(uri: '/ws/question/unfollow')}/${question.id}/${to.currentUserId()}";

            $.ajax({
                url: $(this).hasClass('active') ? unfollowURL : followURL,
                dataType: "json",
                success: function(data) {
                    $('#refreshFollowingZoneLink').click();
                }
            });
        });

        $(".togglePlaceholder").on("click", function() {
            if (!$(this).hasClass("active")) {
                $(".togglePlaceholder").each(function() {
                    $(this).toggleClass("active");
                });
                $(".placeholder").each(function() {
                    $(this).toggleClass("hidden");
                });
            }

            // This is needed to refresh the map when it is actually shown so it fits the available size
            if(!$("#map").hasClass("hidden")) {
                map.invalidateSize();
            }
        });
    });
</r:script>
</body>
</html>
