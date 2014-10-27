<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="tomain"/>
        <title>Welcome to Grails</title>
        <style type="text/css" media="screen">

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
        <table class="table table-condensed table-striped table-bordered">
            <thead>
                <tr>
                    <th>Id</th>
                    <th>OccurrenceId</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
                <g:each in="${questions}" var="question">
                    <tr questionId="${question.id}">
                        <td>${question.id}</td>
                        <td><g:link action="view" id="${question.id}">${question.occurrenceId}</g:link></td>
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
