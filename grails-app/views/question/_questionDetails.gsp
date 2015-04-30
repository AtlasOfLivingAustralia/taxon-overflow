<%@ page import="au.org.ala.taxonoverflow.QuestionType" %>
<!-- Tabular data -->
<div class="table-responsive">
    <table class="table table-striped table-hover">
        <thead>
        <tr>
            <th>Category</th>
            <th>Details</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td>Recorded by:</td>
            <td>${occurrence['recordedBy']}</td>
        </tr>
        <tr>
            <td>Event date:</td>
            <td>${occurrence['eventDate']}</td>
        </tr>
        <tr>
            <td>Locality:</td>
            <td>${occurrence['locality']}</td>
        </tr>
        <g:if test="${question.questionType != QuestionType.IDENTIFICATION}">
        <tr>
            <td>Scientific name:</td>
            <td>${occurrence['scientificName']}</td>
        </tr>
        <tr>
            <td>Common name:</td>
            <td>${occurrence['commonName']}</td>
        </tr>
        <tr>
            <td>Occurrence remarks:</td>
            <td>${occurrence['occurrenceRemarks']}</td>
        </tr>
        </g:if>
        </tbody>
    </table>
</div>
<!-- End Tabular data -->