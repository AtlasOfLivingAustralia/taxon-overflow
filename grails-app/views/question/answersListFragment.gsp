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

</style>
<div>
  <h3>${answers?.size() ?: 0} ${question.questionType == au.org.ala.taxonoverflow.QuestionType.Identification ? "Identification(s)" : "Answer(s)" }</h3>
  <ul class="answer-list">
    <g:each in="${answers}" var="answer" status="i">
      <g:set var="stripeClass" value="${i % 2 == 0 ? 'striped' : '' }" />
      <g:set var="acceptedClass" value="${answer.accepted ? 'accepted-answer' : ''}" />
      <li answerId="${answer.id}" class="${acceptedClass} ${stripeClass}">
        <g:render template="answerFragment" model="${[question: question, answer: answer, userVote: userVotes[answer], totalVotes: answerVoteTotals[answer]]}" />
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

</script>