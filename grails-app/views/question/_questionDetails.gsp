<%@ page import="au.org.ala.taxonoverflow.QuestionType" %>
<!-- Tabular data -->
<div class="table-responsive">
    <dl class="dl-horizontal">
        <dt>Recorded by:</dt>
        <dd>${occurrence['recordedBy']}</dd>

        <dt>Event date:</dt>
        <dd>${occurrence['eventDate']}</dd>

        <dt>Locality:</dt>
        <dd>${occurrence['locality']}</dd>

        <g:if test="${question.questionType != QuestionType.IDENTIFICATION}">
            <dt>Scientific name:</dt>
            <dd>${occurrence['scientificName']}</dd>

            <dt>Common name:</dt>
            <dd>${occurrence['commonName']}</dd>

            <dt>Occurrence remarks:</dt>
            <dd>${occurrence['occurrenceRemarks']}</dd>
        </g:if>
    </dl>
</div>
<!-- End Tabular data -->