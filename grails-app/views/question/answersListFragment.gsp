<div>
  <h3>${answers?.size() ?: 0} ${question.questionType == au.org.ala.taxonoverflow.QuestionType.Identification ? "identifications" : "answers" }</h3>
  <table class="table table-striped table-condensed">
    <g:each in="${answers}" var="answer">
      <tr>
        <td>
          Votes
        </td>
        <td>
          <to:userDisplayName user="${answer.user}" />
          <br />
          <g:formatDate date="${answer.dateCreated}" format="yyyy-MM-dd" />
        </td>
        <td>
          <g:render template="/question/show${question.questionType.toString()}Answer" model="${[answer: answer]}" />
        </td>
      </tr>
    </g:each>
  </table>

</div>