<%--
  Created by IntelliJ IDEA.
  User: dos009@csiro.au
  Date: 19/03/15
  Time: 5:00 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Your Activity Summary</title>
    <meta name="layout" content="main"/>
    <r:require modules="core"/>
    <r:style type="text/css">
        #profile-content  {
            border-top: 1px solid #637073;
            padding-top: 5px;
        }
        h1, h2, h3, h4, h5 {
          font-weight: 400;
        }
        #gravatar {
            margin-right: 15px;
        }
    </r:style>
</head>
<body>
<div class="row">
    <div class="span12">
        <ul class="breadcrumb">
            <li><a href="http://ala.org.au">Home</a> <span class="divider"><i class="fa fa-arrow-right"></i></span></li>
            <li><g:link controller="question" action="list">Community identification help</g:link> <span class="divider"><i class="fa fa-arrow-right"></i></span></li>
            <li class="active">Activity Summary</li>
        </ul>
    </div>
</div><h2>Activity Summary</h2>

<div class="row">
    <div class="span3">
        <h4 style="display: inline-block">${raw((user.displayName) ? user.displayName : "")}</h4>
        <div id="avatar">
            <a href="https://en.gravatar.com/" id="gravatar" target="_blank" title="Your Gravatar image, click to edit"><avatar:gravatar email="${user.email}" alt="My Avatar" size="70" gravatarRating="G" defaultGravatarUrl="identicon"/></a>
            ${'INST_NOT_AVAIL'}
            ${'EXPERT_IN_AREA'}
        </div>
        &nbsp;
    </div>
    <div class="span5" style="padding-top:20px;">
        <table class="table table-condensed table-bordered table-striped">
            <tr><td>Member since</td><td><g:formatDate date="${new Date()}" format="yyyy-MM-dd"/></td></tr>
            <tr><td>Number of identifications provided</td><td>${0}</td></tr>
            <tr><td>Number of identifications accepted</td><td>${0}</td></tr>
            <tr><td>Tags of interest</td><td>${['birds','mammals','sharks']}</td></tr>
        </table>
    </div>
    <div class="span4" style="padding-top:20px;">
        <div class="well well-small" style="padding-left: 20px;">
            <h3>Manage my alerts</h3>
            <label class="checkbox">
                <g:checkBox name="alertsStatus" id="alertsStatus" value="${user.enableNotifications}"/>
                Send me emails for all my activity updates
            </label>
        </div>

    </div>
</div>

<div class="taxonoverflow-content row-fluid" id="profile-content">
    <div class="span4 ">
        <h4>My Questions</h4>
        <g:render template="listQuestions" model="[questionList: myQuestions, questionLabel: 'questions']"/>
    </div>
    <div class="span4">
        <h4>My Answers</h4>
        <g:render template="listQuestions" model="[questionList: myAnsweredQuestions, questionLabel: 'answers']"/>
    </div>
    <div class="span4">
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