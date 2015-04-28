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
        <h2 class="heading-medium">Activity Summary for ${raw((user.displayName) ? user.displayName : "")}</h2>
    </div>
</div>

<div class="row-fluid">
    <div class="col-md-12">
        <div class="col-md-3">
            <div id="avatar">
                <a href="https://en.gravatar.com/" id="gravatar" target="_blank" title="Your Gravatar image, click to edit"><avatar:gravatar email="${user.email}" alt="My Avatar" size="70" gravatarRating="G" defaultGravatarUrl="identicon"/></a>
                ${'INST_NOT_AVAIL'}
                ${'EXPERT_IN_AREA'}
            </div>
            &nbsp;
        </div>
        <div class="col-md-5">
            <table class="table table-condensed table-bordered table-striped">
                %{--<tr><td>Member since</td><td><g:formatDate date="${new Date()}" format="yyyy-MM-dd"/></td></tr>--}%
                <tr><td>Number of identifications provided</td><td>${0}</td></tr>
                <tr><td>Number of identifications accepted</td><td>${0}</td></tr>
                <tr><td>Tags of interest</td>
                    <td>
                        <g:each in="${user.tags}" var="tag" status="s">
                            <span class="label label-primary"><a href="${g.createLink(uri:'/', params:['f.tags': tag])}" title="view all question with this tag" style="color: white;">${tag}</a></span>
                        </g:each>
                    </td></tr>
            </table>
        </div>
        <div class="col-md-4">
            <div class="well well-small">
                <h3>Manage my alerts</h3>
                <label class="checkbox">
                    <g:checkBox name="alertsStatus" id="alertsStatus" value="${user.enableNotifications}"/>
                    Send me emails for all my activity updates
                </label>
            </div>

        </div>
    </div>
</div>

<div class="taxonoverflow-content row-fluid" id="profile-content">
    <div class="col-md-4">
        <h4>My Questions</h4>
        <g:render template="listQuestions" model="[questionList: myQuestions, questionLabel: 'questions']"/>
    </div>
    <div class="col-md-4">
        <h4>My Answers</h4>
        <g:render template="listQuestions" model="[questionList: myAnsweredQuestions, questionLabel: 'answers']"/>
    </div>
    <div class="col-md-4">
        <h4>Followed Questions</h4>
        <g:render template="listQuestions" model="[questionList: followedQuestions, questionLabel: 'followed questions']"/>
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