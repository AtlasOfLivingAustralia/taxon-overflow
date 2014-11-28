<style>
  .voteCount {
    font-size: large;
    font-weight: bold;
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
    color: #000000;
  }

  .vote-arrow:hover {
    text-decoration: none;
  }

  .vote-arrow-up {
    /*color: darkgreen;*/
  }

  .vote-arrow-down {
    /*color: darkred;*/
  }

  .striped {
    background-color: #F9F9F9;
  }

  .accepted-answer-mark {
    font-size: 4em;
    color: green;
  }

  .user-upvoted {
    color: orange;
    font-size: 1.6em;
  }

  .user-downvoted {
    color: orange;
    font-size: 1.6em;
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
            <g:set var="downvoteClass" value="${userVote?.voteValue < 0 ? 'user-downvoted' : '' }" />
            <a href="#" class="vote-arrow vote-arrow-up ${upvoteClass}">
              <i class="fa fa-thumbs-o-up"></i>
            </a>
            <br/>
            <span class="voteCount">${answerVoteTotals[answer] ?: 0}</span>
            <br />
            <a href="#" class="vote-arrow vote-arrow-down ${downvoteClass}">
              <i class="fa fa-thumbs-o-down"></i>
            </a>

          </div>

          <div class="span2">
            <to:userDisplayName user="${answer.user}" />
          <br />
            <g:formatDate date="${answer.dateCreated}" format="yyyy-MM-dd" />
          </div>
          <div class="span6">
            <g:render template="/question/show${question.questionType.toString()}Answer" model="${[answer: answer]}" />
          </div>
          <div class="span2">
            <span class="pull-right">
              <to:ifCanDeleteAnswer answer="${answer}">
                <button type="button" title="Remove this answer" class="btnDeleteAnswer btn btn-mini btn-danger"><i class="icon-trash icon-white"></i></button>
              </to:ifCanDeleteAnswer>
              <to:ifCanAcceptAnswer answer="${answer}">
                <button type="button" title="Accept this answer" class="btnAcceptAnswer btn btn-mini btn-success"><i class="icon-ok icon-white"></i></button>
              </to:ifCanAcceptAnswer>
            </span>
          </div>
        </div>
      </li>
    </g:each>
  </ul>

</div>

<script>

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
      var voteData = {
        userId: "<to:currentUserId />",
        dir: 1
      };

      if ($(this).hasClass("user-upvoted")) {
        voteData.dir = 0;
      }

      $.post("${createLink(controller:'webService', action:'castVoteOnAnswer')}/" + answerId, voteData, null, "json").done(function(response) {
        if (response.success) {
          if (renderAnswers) {
            renderAnswers();
          }
        } else {
          alert("Voting failed: " + response.message);
        }
      });

    }
  });

  $(".vote-arrow-down").click(function(e) {
    e.preventDefault();
    var answerId = $(this).closest("[answerId]").attr("answerId");
    alert(answerId);
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
            if (renderAnswers) {
              renderAnswers();
            }
          });
        }
      });
    }

  });

</script>