<style>

  .voteCount {
    font-size: large;
    font-weight: bold;
    margin-top: 5px;
    margin-bottom: 5px;
  }

  .answer-list li.accepted-answer {
  }

  .answer-list {
    list-style: none;
    margin-left: 0;
    border: 1px solid #dddddd;
  }

  .answer-list li {
    padding: 10px;
  }

  .vote-arrow {
    font-size: 1.5em;
    border: 1px solid #dddddd;
    border-radius: 3px;
    padding: 3px;
    text-decoration: none;
    color: dimgray;
  }

  a.vote-arrow, a.vote-arrow:hover, a.vote-arrow:visited {
    text-decoration: none;
    color: dimgray;
  }

  .vote-arrow-up {
  }

  .vote-arrow-down {
  }

  .striped {
    background-color: #F9F9F9;
  }

  .accepted-answer-mark {
    font-size: 4em;
    color: green;
  }

  .user-upvoted, .user-upvoted:hover {
    color: green;
    font-size: 1.6em;
  }

  .user-downvoted, .user-downvoted:hover {
    color: orangered;
    font-size: 1.6em;
  }

  .answer-buttons .btn i {
    font-size: 1.2em;
  }

  .answer-buttons .btn.btnDeleteAnswer i {
    color: red;
  }

  .answer-buttons .btn.btnAcceptAnswer i {
    color: green;
  }

</style>
<div>
  <h3>${answers?.size() ?: 0} ${question.questionType == au.org.ala.taxonoverflow.QuestionType.Identification ? "Identification(s)" : "Answer(s)" }</h3>
  <ul class="answer-list">
    <g:each in="${answers}" var="answer" status="i">
      <g:set var="stripeClass" value="${i % 2 == 0 ? 'striped' : '' }" />
      <g:set var="acceptedClass" value="${answer.accepted ? 'accepted-answer' : ''}" />
      <li answerId="${answer.id}" class="${acceptedClass} ${stripeClass}">
        <div class="row-fluid">

          <div class="span1">
            <g:if test="${answer.accepted}">
              <to:ifCanAcceptAnswer answer="${answer}">
                <a href="#" title="Click to undo acceptance of this answer." class="btnUnacceptAnswer">
                  <i class="accepted-answer-mark fa fa-check"></i>
                </a>
              </to:ifCanAcceptAnswer>
              <to:ifCannotAcceptAnswer answer="${answer}">
                <i class="accepted-answer-mark fa fa-check"></i>
              </to:ifCannotAcceptAnswer>
            </g:if>
          </div>

          <div class="span1" style="text-align: center">
            <g:set var="userVote" value="${userVotes[answer]}" />
            <g:set var="upvoteClass" value="${userVote?.voteValue > 0 ? 'user-upvoted' : '' }" />
            <g:set var="downvoteClass" value="${userVote?.voteValue && userVote?.voteValue < 0 ? 'user-downvoted' : '' }" />
            <div>
              <a href="#" class="vote-arrow vote-arrow-up ${upvoteClass}">
                <i class="fa fa-thumbs-o-up"></i>
              </a>
            </div>
            <div class="voteCount">${answerVoteTotals[answer] ?: 0}</div>
            <div>
              <a href="#" class="vote-arrow vote-arrow-down ${downvoteClass}">
                <i class="fa fa-thumbs-o-down"></i>
              </a>
            </div>

          </div>

          <div class="span2">
            <to:userDisplayName user="${answer.user}" />
          <br />
            <g:formatDate date="${answer.dateCreated}" format="yyyy-MM-dd" />
          </div>
          <div class="span5">
            <g:render template="/question/show${question.questionType.toString()}Answer" model="${[answer: answer]}" />
          </div>
          <div class="span3">
            <span class="pull-right answer-buttons">
              <to:ifCanEditAnswer answer="${answer}">
                <button type="button" title="Edit this answer" class="btnEditAnswer btn btn-small"><i class="fa fa-edit"></i></button>
                <button type="button" title="Remove this answer" class="btnDeleteAnswer btn btn-small"><i class="fa fa-remove"></i></button>
              </to:ifCanEditAnswer>
              <to:ifCanAcceptAnswer answer="${answer}">
                <button type="button" title="Accept this answer" class="btnAcceptAnswer btn btn-small"><i class="fa fa-check"></i></button>
              </to:ifCanAcceptAnswer>
            </span>
          </div>
        </div>
      </li>
    </g:each>
  </ul>

</div>
<g:if test="${(userAnswers?.size() ?: 0) == 0}">
  <div class="newAnswerDiv">
    <div class="row-fluid">
      <div class="span12">
        <to:renderAnswerTemplate question="${question}" />
      </div>
    </div>
    <div class="row-fluid">
      <div class="span12">
        <button class="btn btn-success pull-right" id="btnSubmitAnswer">Submit identification</button>
      </div>
    </div>
  </div>
</g:if>
<g:else>
  <div class="existing-answer-message">
    You have already supplied an identification. Click <a href="#" class="editAnswerLink" answerId="${userAnswers[0].id}">here</a> to edit it.
  </div>
</g:else>


<script>

  function editAnswer(answerId) {
    if (answerId) {
      tolib.showModal( {
        url: "${createLink(controller:'dialog', action:'editAnswerFragment')}?answerId=" + answerId,
        title: "",
        hideHeader: true
      });
    }
  }

  $(".btnEditAnswer").click(function(e) {
    e.preventDefault();
    var answerId = $(this).closest("[answerId]").attr("answerId");
    if (answerId) {
      editAnswer(answerId);
    }
  });

  $(".editAnswerLink").click(function(e) {
    e.preventDefault();
    var answerId = $(this).attr("answerId");
    if (answerId) {
      editAnswer(answerId);
    }
  });

  function clearErrorMessages() {
    $(document).remove(".to-error-message");
  }

  function errorMessage(target, message) {
    clearErrorMessages();
    $(target).prepend('<div class="alert alert-error to-error-message">' + message + '</div>');

  }

  function submitAnswer(options) {

    var answer = { questionId: ${question.id}, userId: "${user.alaUserId}" };

    $(".newAnswerDiv .answer-field").each(function() {
      answer[$(this).attr("id")] = $(this).val();
    });

    tolib.doJsonPost("${createLink(controller: 'webService', action:'submitAnswer', id:question.id)}", answer).done(function(response) {

      if (response.success) {
        renderAnswers();
        if (options && options.onSuccess instanceof Function) {
          options.onSuccess();
        }
      } else {
        errorMessage($("#newAnswerDiv"), response.message);
        if (options && options.onFailure instanceof Function) {
          options.onFailure();
        }
      }
    }).always(function() {
      if (options && options.onComplete instanceof Function) {
        options.onComplete();
      }
    }).error(function() {
      errorMessage($("#newAnswerDiv"), response.message)
    })

  }

  $("#btnSubmitAnswer").click(function(e) {
    e.preventDefault();

    $("#btnSubmitAnswer").attr("disabled","disabled");

    submitAnswer({
      onComplete: function() {
        $("#btnSubmitAnswer").removeAttr("disabled");
      },
      onSuccess: function() {
        $(".answer-field").val("");
      }
    });

  });

  $(".btnUnacceptAnswer").click(function(e) {
    e.preventDefault();
    var answerId = $(this).closest("[answerId]").attr("answerId");
    if (answerId) {
      var url = "${createLink(controller: 'webService', action:'unacceptAnswer')}/" + answerId;
      $.post(url).done(function (results) {
        location.reload(true);
      });
    }
  });

  $(".vote-arrow-up").click(function(e) {
    e.preventDefault();
    var answerId = $(this).closest("[answerId]").attr("answerId");
    if (answerId) {
      voteOnAnswer(answerId, 1);
    }
  });

  function voteOnAnswer(answerId, direction) {
    var voteData = {
      userId: "<to:currentUserId />",
      dir: direction
    };

    $.post("${createLink(controller:'webService', action:'castVoteOnAnswer')}/" + answerId, voteData, null, "json").done(function(response) {
      if (response.success) {
        if (renderAnswers) {
          renderAnswers();
        }
      } else {
        alert(response.message);
      }
    });

  }

  $(".vote-arrow-down").click(function(e) {
    e.preventDefault();
    var answerId = $(this).closest("[answerId]").attr("answerId");
    if (answerId) {
      voteOnAnswer(answerId, -1);
    }

  });

  $(".btnAcceptAnswer").click(function(e) {
    e.preventDefault();
    var answerId = $(this).closest("[answerId]").attr("answerId");
    if (answerId) {
      var url = "${createLink(controller: 'webService', action:'acceptAnswer')}/" + answerId;
      $.post(url).done(function(results) {
        location.reload(true);
      });
    }
  });

  $(".btnDeleteAnswer").click(function(e) {
    e.preventDefault();
    var answerId = $(this).closest("[answerId]").attr("answerId");
    if (answerId) {
      tolib.areYouSure({
        message: 'Are you sure you wish to permanently delete this answer?',
        title: 'Delete your answer?',
        affirmativeAction: function () {
          var url = "${createLink(controller: 'webService', action:'deleteAnswer')}/" + answerId;
          $.post(url).done(function(results) {
            location.reload(true);
          });
        }
      });
    }

  });

</script>