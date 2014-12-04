<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="tomain"/>
        <title>Welcome to Grails</title>
        <style>
        <r:style>

            .question-thumb {
                height: 100px;
                max-height: 100px;
            }

        </r:style>
        </style>
        <r:script>

            $(document).ready(function() {

                $(".btnDelete").click(function(e) {
                    e.preventDefault();
                    var questionId = $(this).closest("[questionId]").attr("questionId");
                    if (questionId) {
                        tolib.areYouSure({
                            title: "Delete question", message: "Are you sure you wish to delete this question?",
                            affirmativeAction: function() {
                                window.location = "${createLink(action:'delete')}/" + questionId;
                            }
                        })
                    }
                });

            });
        </r:script>

    </head>
    <body class="content">
        ${questions.size()} questions
        <table class="table table-condensed table-striped table-bordered">
            <tbody>
                <g:each in="${questions}" var="question">
                    <tr questionId="${question.id}">
                        <td style="width: 110px">
                            <g:set var="questionUrl" value="${createLink(controller:'question', action:'view', id: question.id)}" />
                            <g:if test="${imageInfoMap[question.occurrenceId]}">
                                <a class="thumbnail" href="${questionUrl}">
                                    <img class="question-thumb" src="${imageInfoMap[question.occurrenceId][0]?.squareThumbUrl}_darkGray" />
                                </a>
                            </g:if>
                        </td>
                        <td><g:link action="view" id="${question.id}">${question.occurrenceId}</g:link></td>
                        <td><to:userDisplayName user="${question.user}" /></td>
                        <td><button type="button" class="btn btn-small btn-danger btnDelete"><i class="icon-remove icon-white"></i></button></td>
                    </tr>
                </g:each>
            </tbody>
            <div class="pagination">
                <g:paginate total="${totalCount}" />
            </div>
        </table>
    </body>
</html>
