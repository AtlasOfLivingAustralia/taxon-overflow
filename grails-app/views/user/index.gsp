<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Your Activity Summary</title>
    <meta name="layout" content="main"/>
    <r:require modules="taxonoverflow-common"/>
</head>
<body>

<div class="row-fluid">
    <div class="col-md-12">
        <ol class="breadcrumb">
            <li><a class="font-xxsmall" href="http://ala.org.au">Home</a></li>
            <li><a class="font-xxsmall" href="${g.createLink(controller:"question", action:"list")}">Community identification help</a></li>
            <li class="font-xxsmall active">Activity Summary</li>
        </ol>
    </div>
</div>

<div class="row-fluid">
    <div class="col-md-12">
        <h2 class="heading-medium">Activity Summary for <span class="comment-author">${userDetails.displayName}</span></h2>
    </div>
</div>

<!-- Panel content -->
<div class="row-fluid" id="summary">
    <div class="col-md-12">
        <div class="panel panel-default">
            <div class="panel-heading question-heading">
                <h3 class="heading-underlined">Summary</h3>
            </div>

            <div class="panel-body row">
                <div class="col-sm-4">
                    <div class="well">
                        <div class="row">
                            <div class="col-sm-12 text-center">
                                <a href="https://en.gravatar.com/" class="thumbnail profile-gravatar" target="_blank" title="Your Gravatar image, click to edit">
                                    <avatar:gravatar email="${userDetails.userName}" alt="My Avatar" size="100" gravatarRating="G" defaultGravatarUrl="identicon"/>
                                </a>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-12">
                                <label>Name</label>
                                <p>${userDetails.displayName}</p>

                                <label>Organisation</label>
                                <p>${userDetails.organisation}</p>

                                <label>Number of answers provided</label>
                                <p>${myAnsweredQuestions?.size()}</p>

                                <label>Number of answers accepted</label>
                                <p>${userAnswersAccepted?.size()}</p>

                                <label>Tags of interest</label>
                                <p>
                                    <g:each in="${user.tags}" var="tag" status="s">
                                    <span class="label label-primary"><a href="${g.createLink(uri:'/', params:['f.tags': tag])}" title="view all question with this tag" style="color: white;">${tag}</a></span>
                                    </g:each>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-8">
                    <div role="tabpanel">
                        <!-- Nav tabs -->
                        <ul class="nav nav-tabs" role="tablist">
                            <li class="active"><a href="#alerts" aria-controls="home" data-toggle="tab">Alerts</a></li>
                            <li><a href="#questions" aria-controls="profile" data-toggle="tab">Questions</a></li>
                            <li><a href="#answers" aria-controls="messages" data-toggle="tab">Answers</a></li>
                            <li><a href="#following" aria-controls="settings" data-toggle="tab">Questions followed</a></li>
                        </ul>

                        <!-- Tab panes -->
                        <div class="tab-content">
                            <div class="tab-pane active" id="alerts">
                                <form>
                                    <div class="checkbox">
                                        <label>
                                            <g:checkBox name="alertsStatus" id="alertsStatus" value="${user.enableNotifications}"/>
                                            Send me emails for all my activity updates
                                        </label>
                                    </div>
                                </form>
                            </div>
                            <div class="tab-pane" id="questions">
                                <g:render template="listQuestions" model="[questionList: myQuestions, questionLabel: 'questions']"/>
                            </div>
                            <div class="tab-pane" id="answers">
                                <g:render template="listQuestions" model="[questionList: myAnsweredQuestions, questionLabel: 'answers']"/>
                            </div>
                            <div class="tab-pane" id="following">
                                <g:render template="listQuestions" model="[questionList: followedQuestions, questionLabel: 'followed questions']"/>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<r:script>
    $(document).ready(function () {
        $('#gravatar').tooltip({placement: 'right'});

        var eventStatusBool = $('#alertsStatus').is(':checked');
        $('#alertsStatus').on('change', function(e) {
            e.preventDefault();
            eventStatusBool = $('#alertsStatus').is(':checked');
            var action = (eventStatusBool) ? 'enable' : 'disable';
            $.get("${g.createLink(uri:'/ws/user/notifications/')}" + action)
            .done(function(data) {
                if (data.success) {
                    alert('Your settings have been changed');
                } else {
                    alert('Error. Your settings were NOT saved. ' + data.message);
                    $('#alertsStatus').attr('checked', !eventStatusBool); // reset back to original value
                }
            })
            .fail(function( jqXHR, textStatus, errorThrown ) {
                alert("Error: " + textStatus + " - " + errorThrown);
                $('#alertsStatus').attr('checked', !eventStatusBool); // reset back to original value
            });
        });
    }); // end document.ready
</r:script>
</body>
</html>