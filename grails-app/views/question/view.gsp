<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Case #${question.id} | Community identification help | Atlas of Living Australia</title>
    <r:require modules="viewer, flexisel, leaflet, taxonoverflow, ajaxanywhere, bootbox" />
    <r:script>

        var GSP_VARS = {
            leafletImagesDir: "${resource(plugin: 'images-client-plugin', dir: 'js/leaflet/images')}"
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
            <div class="panel-heading">
                <h3 class="heading-underlined">Application Overview</h3>
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
                        <li class="font-xxsmall ${question.answers ? 'active' : ''}"><a href="#answersPane" data-toggle="tab">Add Answers</a></li>
                        <li class="font-xxsmall ${!question.answers ? 'active' : ''}"><a href="#commentsPane" data-toggle="tab">Add Comments</a></li>
                    </ul>

                    <!-- Tab sections -->
                    <div class="tab-content">
                        <div class="tab-pane ${question.answers ? 'active' : ''}" id="answersPane">

                            <div class="btn-group padding-bottom-1">
                                <p>Help the ALA by adding an answer or comments to existing answers.</p>
                                <a class="btn btn-primary btn-lg pull-right" href="#identification" data-toggle="modal">Add an identification</a>
                            </div>

                            <div class="panel panel-success">
                                <div class="panel-heading heading-underlined"><h4 class="heading-underlined">Accepted answer</h4></div>
                                <div class="panel-body">
                                    <div class="row">
                                        <div class="col-md-8">
                                            <div class="padding-bottom-1">
                                                <h4>Homo sapiens: Human, Man</h4>
                                                <small>Identified by <a href="#">Dave Martin</a> 2 days ago</small>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <p><span class="stat__number">23</span> votes</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel-footer">
                                    <a class="btn btn-primary" href="#comment" data-toggle="modal">Add a comment</a>
                                    <div class="btn btn-group">
                                        <a class="btn btn-default" href="#"><i class="fa fa-thumbs-o-up"></i></a>
                                        <a class="btn btn-default" href="#"><i class="fa fa-thumbs-o-down"></i></a>
                                    </div>

                                </div>
                                <div class="panel-footer comments">

                                    <div class="row">
                                        <div class="comment public_comment">
                                            <div class="comment-wrapper ">
                                                <div class="body">
                                                    <div class="col-md-12">
                                                        <div class="ident-question heading-underlined">I have found this. What is it?</div>
                                                        <div class="contrib-time">27 minutes ago by <a href="#">Adam Atteia</a></div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </div>

                            <div class="panel panel-default">
                                <div class="panel-heading"><h4 class="heading-underlined">Closest answer</h4></div>
                                <div class="panel-body">
                                    <div class="row">
                                        <div class="col-md-8">
                                            <div class="padding-bottom-1">
                                                <h4>Homo sapiens: Servant, Public</h4>
                                                <small>Identified by <a href="#">Tony Abbott</a> 3 days ago</small>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <p><span class="stat__number">7</span> votes</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel-footer">
                                    <a class="btn btn-primary" href="#comment" data-toggle="modal">Add a comment</a>
                                    <div class="btn btn-group">
                                        <a class="btn btn-default" href="#"><i class="fa fa-thumbs-o-up"></i></a>
                                        <a class="btn btn-default" href="#"><i class="fa fa-thumbs-o-down"></i></a>
                                    </div>
                                </div>
                                <div class="panel-footer comments">

                                    <div class="row">
                                        <div class="comment public_comment">
                                            <div class="comment-wrapper push">
                                                <div class="body">
                                                    <div class="col-md-12">
                                                        <div class="ident-question heading-underlined"><a href="#">@Adam Atteia</a> That's definitely not right.</div>
                                                        <div class="contrib-time">2 minutes ago by <a href="#">Trevor Phillips</a></div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="comment public_comment">
                                            <div class="comment-wrapper push">
                                                <div class="body">
                                                    <div class="col-md-12">
                                                        <div class="ident-question heading-underlined"><a href="#">@Pikachu</a> I don't think that's right ...</div>
                                                        <div class="contrib-time">8 minutes ago by <a href="#">Adam Atteia</a></div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="comment public_comment">
                                            <div class="comment-wrapper push">
                                                <div class="body">
                                                    <div class="col-md-12">
                                                        <div class="ident-question heading-underlined">This is a rare form of the silver pokemon found in the dark green patch of the northern maps of India.</div>
                                                        <div class="contrib-time">27 minutes ago by <a href="#">Pikachu (I love you)</a></div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </div>

                            <div class="panel panel-default">
                                <div class="panel-heading"><h4 class="heading-underlined">Answer</h4></div>
                                <div class="panel-body">
                                    <div class="row">
                                        <div class="col-md-8">
                                            <div class="padding-bottom-1">
                                                <h4>Homo sapiens: Lawyer, Crimefighter</h4>
                                                <small>Identified by <a href="#">Daredevil, the Man Without Fear</a> 3 days ago</small>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <p><span class="stat__number">4</span> votes</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel-footer">
                                    <a class="btn btn-primary" href="#comment" data-toggle="modal">Add a comment</a>
                                    <div class="btn btn-group">
                                        <a class="btn btn-default" href="#"><i class="fa fa-thumbs-o-up"></i></a>
                                        <a class="btn btn-default" href="#"><i class="fa fa-thumbs-o-down"></i></a>
                                    </div>
                                </div>
                            </div>

                        </div>

                        <div class="tab-pane ${!question.answers ? 'active' : ''}" id="commentsPane">
                            <!-- This is the additional comments tab content -->

                            <!-- <h3 class="heading-medium">Answers</h3> -->
                            <p>Add a comment or question below.</p>

                            <form class="form-horizontal padding-bottom-2">
                                <!-- <div class="form-group">
                      <label for="inputEmail3" class="col-sm-3 control-label">Name</label>
                      <div class="col-sm-8">
                        <input type="email" class="form-control" id="inputEmail3" placeholder="Full name">
                      </div>
                    </div> -->
                                <div class="form-group">
                                    <label for="" class="col-sm-3 control-label">Comments or questions</label>
                                    <div class="col-sm-8">
                                        <textarea class="form-control" rows="4" placeholder="Enter your comments or questions"></textarea>
                                        <!-- <p class="help-block">Example block-level help text here.</p> -->
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="col-sm-offset-3 col-sm-8">
                                        <button type="submit" class="btn btn-primary btn-lg">Submit comment</button>
                                    </div>
                                </div>
                            </form>

                            <div class="comment public_comment">

                                <div class="alert push">
                                    <div class="body">
                                        <span class="comment-icon"><i class="fa fa-comment"></i></span>
                                        <div class="time">27 minutes ago</div>
                                        <div class="author">aatteia published a comment</div>
                                        <div class="details">Do aliens really exist? And if not, then what is up with Christopher Pine?</div>
                                    </div>
                                </div>

                                <div class="alert push">
                                    <div class="body">
                                        <span class="comment-icon"><i class="fa fa-comment"></i></span>
                                        <div class="time">27 minutes ago</div>
                                        <div class="author">aatteia published a comment</div>
                                        <div class="details">Do aliens really exist? And if not, then what is up with Christopher Pine?</div>
                                    </div>
                                </div>

                                <div class="alert push">
                                    <div class="body">
                                        <span class="comment-icon"><i class="fa fa-comment"></i></span>
                                        <div class="time">27 minutes ago</div>
                                        <div class="author">aatteia published a comment</div>
                                        <div class="details">Do aliens really exist? And if not, then what is up with Christopher Pine?</div>
                                    </div>
                                </div>

                                <div class="alert push">
                                    <div class="body">
                                        <span class="comment-icon"><i class="fa fa-comment"></i></span>
                                        <div class="time">27 minutes ago</div>
                                        <div class="author">aatteia published a comment</div>
                                        <div class="details">Do aliens really exist? And if not, then what is up with Christopher Pine?</div>
                                    </div>
                                </div>

                                <div class="alert push">
                                    <div class="body">
                                        <span class="comment-icon"><i class="fa fa-comment"></i></span>
                                        <div class="time">27 minutes ago</div>
                                        <div class="author">aatteia published a comment</div>
                                        <div class="details">Do aliens really exist? And if not, then what is up with Christopher Pine?</div>
                                    </div>
                                </div>

                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<aa:zone id="addTagDialogZone"></aa:zone>
</body>
</html>
