<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main"/>
        <title>Welcome to Grails</title>
        <style type="text/css" media="screen">

        </style>
    </head>
    <body class="content">
        <table class="table table-condensed table-striped">
            <thead>
                <tr>
                    <th>Id</th>
                    <th>OccurrenceId</th>
                </tr>
            </thead>
            <tbody>
                <g:each in="${subjects}" var="subject">
                    <tr>
                        <td>${subject.id}</td>
                        <td>${subject.occurrenceId}</td>
                    </tr>
                </g:each>
            </tbody>
            <div class="pagination">
                <g:paginate total="${totalCount}" />
            </div>
        </table>
    </body>
</html>
