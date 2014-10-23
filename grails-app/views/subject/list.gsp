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
                    var subjectId = $(this).closest("[subjectId]").attr("subjectId");
                    alert(subjectId);
                    if (subjectId) {
                        if (tolib.areYouSure({"question":"Are you wish to delete this subject?"})) {
                            alert("delete " + subjectId);
                        }
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
                <g:each in="${subjects}" var="subject">
                    <tr subjectId="${subject.id}">
                        <td>${subject.id}</td>
                        <td>${subject.occurrenceId}</td>
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
