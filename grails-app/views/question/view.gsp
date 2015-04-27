<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Case #${question.id} | Community identification help | Atlas of Living Australia</title>
    <r:script>
        var GSP_VARS = {
            leafletImagesDir: "${resource(plugin: 'images-client-plugin', dir: 'js/leaflet/images')}"
        };

        var images = [];
        <g:each in="${occurrence.imageIds}" var="imageId">
            images.push("${imageId}");
        </g:each>

        $(function() {
            taxonoverflow.init({
                images: images,
                followURL: "${g.createLink(uri: '/ws/question/follow')}/${question.id}/${to.currentUserId()}",
                unfollowURL: "${g.createLink(uri: '/ws/question/unfollow')}/${question.id}/${to.currentUserId()}"
            });
        });
    </r:script>
    <r:require modules="taxonoverflow-view" />
</head>
<body>

<div class="row-fluid">
    <div class="col-sm-9">
        <ol class="breadcrumb">
            <li><a class="font-xxsmall" href="http://ala.org.au">Home</a></li>
            <li><a class="font-xxsmall" href="${g.createLink(controller:"question", action:"list")}">Community identification help</a></li>
            <li class="font-xxsmall active">Species identification case #${question.id}</li>
        </ol>
    </div>

    <div class="col-sm-3 activity-summary">
        <a class="btn btn-primary" href="${g.createLink(uri: '/user')}">Your activity summary</a>
    </div>
</div>

<div class="row-fluid">
    <div class="col-md-7">
        <h2 class="heading-medium">Species identification case #${question.id}</h2>
    </div>
    <to:canShowUserSwitch>
    <div class="col-md-5">
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
    </div>
    </to:canShowUserSwitch>
</div>

<!-- Panel content -->
<div class="row-fluid">
    <div class="col-md-12">
        <div class="panel panel-default">
            <div class="panel-heading question-heading">
                <h3 class="heading-underlined">Information Overview</h3>
            </div>

            <div class="panel-body row">
                <div class="col-xs-12 col-sm-12 col-md-6">

                    <div id="infoAlert2" class="alert alert-info alert-dismissible" role="alert">
                        <button info-alert="infoAlert2" type="button" class="close info-alert-close-btn" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <strong>Welcome to the Species Identification page.</strong>
                        On this page you will find information related to the topic question, including images, map information, author, date and location. As well as accepted answers and comments relating to the question topic.
                    </div>

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
                            <aa:zone id="mapzone" fragmentUrl="${g.createLink(action: 'mapFragment', id: question.id)}">
                            </aa:zone>
                        </div>
                        </g:if>
                    </g:if>

                    <div id="tags-group" class="btn-group">
                        <aa:zone id="tagsZone">
                            <g:render template="tagsFragment" model="${[question: question]}" />
                        </aa:zone>
                        <a aa-refresh-zones="tagsZone" href="${g.createLink(action:'questionTagsFragment', id: question.id)}" id="refreshTagsLink" class="hidden"></a>
                    </div>

                     <g:render template="questionDetails" model="${[question:question, occurrence: occurrence]}" />

                </div>
                <div class="col-xs-12 col-sm-12 col-md-6">

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
</body>
</html>
