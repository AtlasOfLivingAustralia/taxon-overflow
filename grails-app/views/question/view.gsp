<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Case #${question.id} | Community identification help | Atlas of Living Australia</title>
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
            });

            $("#btnSaveTag").click(function(e) {
                e.preventDefault();
                tolib.showModal( {
                    url: "${createLink(controller: 'dialog', action: 'addQuestionTagFragment', params: [questionId: question.id])}",
                    title: "Add tag",
                    hideHeader: false,
                    onClose: function() {
                        if (renderAnswers instanceof Function) {
                            renderTags();
                        }
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

            renderMap();
            $('#map').addClass('hidden');

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
                $("#map").html(content);
            });
        }


    </r:script>
</head>
<body>

<div class="col-md-12">
    <h1 class="hidden">Welcome the Atlas of Living Australia</h1>
    <ol class="breadcrumb">
        <li><a class="font-xxsmall" href="http://ala.org.au">Home</a></li>
        <li><a class="font-xxsmall" href="${g.createLink(controller:"question", action:"list")}">Community identification help</a></li>
        <li class="font-xxsmall active">Species identification case #${question.id}</li>
    </ol>
    <h2 class="heading-medium">Species identification case #${question.id}</h2>
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
                    <p>Instructions here.</p>
                    <div class="btn-group padding-bottom-1">
                        <a class="btn btn-default active togglePlaceholder" href="#"><i class="fa fa-picture-o"></i> <span class="hidden-xs">Toggle image</span></a>
                        <a class="btn btn-default togglePlaceholder" href="#"><i class="fa fa-map-marker"></i> <span class="hidden-xs">Toggle map</span></a>
                    </div>

                    <div class="btn-group padding-bottom-1 pull-right">
                        <to:ifCanEditQuestion question="${question}">
                            <button type="button" class="btn btn-primary" id="btnSaveTag"><i class="fa fa-tag"></i> Add Tag</button>
                        </to:ifCanEditQuestion>

                    </div>

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
                        <div id="map" class="placeholder img-responsive">

                        </div>
                        </g:if>
                    </g:if>

                    <g:render template="tagsFragment" model="${[question: question]}" />

                    <g:render template="questionDetails" model="${[question:question, occurrence: occurrence]}" />




                </div>
                <div class="col-xs-12 col-sm-7 col-md-6">
                    <!-- <h3 class="heading-medium">Answers</h3> -->
                    <p>Instructions: add a comment or question below.</p>

                    <form class="form-horizontal">
                        <div class="form-group">
                            <label for="inputEmail3" class="col-sm-3 control-label">Name</label>
                            <div class="col-sm-8">
                                <input type="email" class="form-control" id="inputEmail3" placeholder="Full name">
                                <!-- <p class="help-block">Example block-level help text here.</p> -->
                            </div>
                        </div>
                        <!-- <div class="form-group">
                  <label for="inputEmail3" class="col-sm-2 control-label">Email</label>
                  <div class="col-sm-9">
                    <input type="email" class="form-control" id="inputEmail3" placeholder="Email">
                    <p class="help-block">Provide your email address if you would like to be contacted.</p>
                  </div>
                </div> -->
                        <!-- <div class="form-group">
                  <label for="inputPassword3" class="col-sm-2 control-label">Website</label>
                  <div class="col-sm-9">
                    <input type="website" class="form-control" id="inputPassword3" placeholder="Website address">
                    <p class="help-block">I have no idea why we want your email address ...</p>
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

                    <!-- Tab navigation -->
                    <ul class="nav nav-tabs">
                        <li class="active font-xxsmall"><a href="#tab3" data-toggle="tab">Answers</a></li>
                        <li class="font-xxsmall"><a href="#tab4" data-toggle="tab">Additional comments</a></li>
                    </ul>

                    <!-- Tab sections -->
                    <div class="tab-content">
                        <div class="tab-pane active" id="tab3">

                            <div class="panel panel-success">
                                <div class="panel-heading heading-underlined"><h4 class="heading-underlined">Accepted answer</h4></div>
                                <div class="panel-body">
                                    <div class="row">
                                        <div class="col-md-8">
                                            <div class="padding-bottom-1">
                                                <h4>Homo sapiens: Human, Man</h4>
                                                <small>Identified by Dave Martin 2 days ago</small>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <p><span class="stat__number">23</span> votes</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel-footer">
                                    <a class="btn btn-primary" href="#">Add a comment on this identification</a>
                                    <div class="btn btn-group">
                                        <a class="btn btn-default" href="#"><i class="fa fa-thumbs-o-up"></i></a>
                                        <a class="btn btn-default" href="#"><i class="fa fa-thumbs-o-down"></i></a>
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
                                                <small>Identified by Tony Abbott 3 days ago</small>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <p><span class="stat__number">7</span> votes</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel-footer">
                                    <a class="btn btn-primary" href="#">Add a comment on this identification</a>
                                    <div class="btn btn-group">
                                        <a class="btn btn-default" href="#"><i class="fa fa-thumbs-o-up"></i></a>
                                        <a class="btn btn-default" href="#"><i class="fa fa-thumbs-o-down"></i></a>
                                    </div>
                                </div>
                            </div>

                        </div>

                        <div class="tab-pane" id="tab4">
                            <!-- This is the additional comments tab content -->

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


<hr/>

        <div class="row">
            <div class="span9">
                <ul class="breadcrumb">
                    <li><a href="http://ala.org.au">Home</a> <span class="divider"><i class="fa fa-arrow-right"></i></span></li>
                    <li><g:link controller="question" action="list">Community identification help</g:link> <span class="divider"><i class="fa fa-arrow-right"></i></span></li>
                    <li class="active">Species identification case #${question.id}</li>
                </ul>
            </div>
            <div class="span3" style="text-align: right;"><a href="${g.createLink(uri:'/user')}">Your activity summary</a></div>
        </div>

        <g:if test="${grailsApplication.config.testUsers}">
        <div class="pull-right" style="position:absolute; top:85px; right:30px;">
            <ul class="nav nav-pills">
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
        </g:if>

        <div class="row-fluid header-row">
            <div class="span6">
                <H1>Species identification case #${question.id}&nbsp;
                    <small> Views: ${viewCount}</small>
                </H1>
            </div>
            <div class="span6">
                <h4 class="pull-right">${question.answers?.size() ?: 0} ${question.questionType == au.org.ala.taxonoverflow.QuestionType.IDENTIFICATION ? "IDENTIFICATION(s)" : "Answer(s)" }</h4>
            </div>
        </div>
        <div class="row-fluid">

            <g:if test="${occurrence.imageIds || coordinates}">
            <div class="span6">
                // Images
                // Map
            </div>
            </g:if>
            <div class="span6">
                <div id="followQuestion">
                    <i class="fa ${isFollowing ? 'fa-star following' : 'fa-star-o'} fa-lg"></i>
                    <span id="followingText" style="${isFollowing ? '' : 'display:none;'}"> Following</span>
                    <span id="unfollowingText"  style="${isFollowing ? 'display:none' : ''}"> Not following</span>
                </div>
                <div id="tagsDiv">
                    // Tags

                </div>
                <div class="occurrenceDetails">
                    // question details
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
