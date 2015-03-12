<style>

  .newAnswerDiv {
      border: 1px solid #dddddd;
      border-radius: 4px;
      padding: 10px;
  }

  .answer-list li.accepted-answer {
      border: 2px solid darkgreen;
      border-radius: 2px;
  }

  .answer-list {
      list-style: none;
      margin-left: 0;
  }

  .answer-list > li {
      padding: 10px;
      border: 1px solid #dddddd;
      margin-bottom: 20px;
  }

</style>
<div>
  <g:if test="${answers?.size() > 0}" >
    <ul class="answer-list">
      <g:each in="${answers}" var="answer" status="i">
        <g:set var="stripeClass" value="${i % 2 == 0 ? '' : '' }" />
        <g:set var="acceptedClass" value="${answer.accepted ? 'accepted-answer' : ''}" />
        <li answerId="${answer.id}" class="${acceptedClass} ${stripeClass}">
          <g:render template="answerFragment" model="${[question: question, answer: answer, userVote: userVotes[answer], totalVotes: answerVoteTotals[answer]]}" />
        </li>
      </g:each>
    </ul>
  </g:if>
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

  function renderAnswer(answerId) {
    // redraws the specified answer (useful when comments etc change).
    if (answerId) {
      $.ajax("${createLink(controller:'question', action:'answerFragment')}/" + answerId).done(function(content) {
        $("li[answerId=" + answerId +"]").html(content);
      });
    }
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

  $("ul.answer-list").on("click", ".btnUpVote", function(e) {
    e.preventDefault();
    var answerId = $(this).closest("[answerId]").attr("answerId");
    if (answerId) {
      voteOnAnswer(answerId, 1);
    }
  });

  $("ul.answer-list").on("click", ".btnDownVote", function(e) {
    e.preventDefault();
    var answerId = $(this).closest("[answerId]").attr("answerId");
    if (answerId) {
      voteOnAnswer(answerId, -1);
    }
  });

  $("ul.answer-list").on("click", ".btnUnacceptAnswer", function(e) {
    e.preventDefault();
    var answerId = $(this).closest("[answerId]").attr("answerId");
    if (answerId) {
      var url = "${createLink(controller: 'webService', action:'unacceptAnswer')}/" + answerId;
      $.post(url).done(function (results) {
        location.reload(true);
      });
    }
  });

  $("ul.answer-list").on("click", ".btnAcceptAnswer", function(e) {
    e.preventDefault();
    var answerId = $(this).closest("[answerId]").attr("answerId");
    if (answerId) {
      var url = "${createLink(controller: 'webService', action:'acceptAnswer')}/" + answerId;
      $.post(url).done(function(results) {
        location.reload(true);
      });
    }
  });

  $("ul.answer-list").on("click", ".btnDeleteAnswer", function(e) {
    e.preventDefault();
    var answerId = $(this).closest("[answerId]").attr("answerId");
    if (answerId) {
        alert(answerId);
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

  $("ul.answer-list").on("click", ".btnAddAnswerComment", function(e) {
    e.preventDefault();
    var answerId = $(this).closest("[answerId]").attr("answerId");
    if (answerId) {
      $.ajax("${createLink(controller:'question', action:'addAnswerCommentFragment')}/" + answerId).done(function(content) {
        $("[answerId=" + answerId + "] .newCommentDiv").html(content);
      });
    }
  });

  $("ul.answer-list").on("click", ".btnDeleteComment", function(e) {
    e.preventDefault();
    var answerId = $(this).closest("[answerId]").attr("answerId");
    var commentId = $(this).closest("[answerCommentId]").attr("answerCommentId");
    if (commentId && answerId) {
      var commentData = {
        userId: "<to:currentUserId />",
        commentId: commentId
      };

      tolib.doJsonPost("${createLink(controller:'webService', action:'deleteAnswerComment')}", commentData).done(function(response) {
        if (renderAnswer && renderAnswer instanceof Function) {
          renderAnswer(answerId);
        }
      });
    }
  });



</script>