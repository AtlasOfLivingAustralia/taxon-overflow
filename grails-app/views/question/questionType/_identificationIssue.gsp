<g:if test="${answerProperties.taxonConceptID}">
    <a href="http://bie.ala.org.au/species/${answerProperties.taxonConceptID}">
</g:if>
<h4>${answerProperties.commonName && answerProperties.scientificName ? "${answerProperties.scientificName} : ${answerProperties.commonName}" : "${answerProperties.scientificName}"}</h4>
<g:if test="${answerProperties.taxonConceptID}">
    </a>
</g:if>
<g:if test="${answerProperties.description}">
    <p class="font-xsmall">${answerProperties.description}</p>
</g:if>