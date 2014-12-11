<g:set var="questionUrl" value="${createLink(controller:'question', action:'view', id: question.id)}" />
<div class="row-fluid">
    <div class="span2 question-meta-panel">
        <a href="${questionUrl}">
            <div class="row-fluid">
                <div class="span6 answer-count-div">
                    <g:set var="answerCount" value="${question.answers?.size()}" />
                    <span class="question-answer-count ${acceptedAnswer ? 'has-accepted-answer' : ''}">${answerCount}</span>
                    <br />
                    ${answerCount == 1 ? 'answer' : 'answers'}
                </div>
                <div class="span6 view-count-div">
                    <span class="question-view-count">${question.views?.size()}</span>
                    <br />
                    views
                </div>
            </div>
            <div class="row-fluid">
                <div class="span6"  style="text-align: center">
                    <g:if test="${acceptedAnswer}" >
                        <i class="accepted-answer-mark fa fa-check"></i>
                    </g:if>
                </div>
                <div class="span6"  style="text-align: center">
                    <g:if test="${acceptedAnswer}">

                        <span class="accepted-answer-text">${acceptedAnswer.scientificName}</span>
                    </g:if>
                </div>
            </div>
        </a>
    </div>
    <div class="span2" style="text-align: center">
        <g:if test="${imageInfo}">
            <a href="${questionUrl}">
                <img class="question-thumb" src="${imageInfo.squareThumbUrl}_darkGray" />
            </a>
        </g:if>
    </div>
    <div class="span8">
        <div class="row-fluid">
            <div class="span12">
                <to:occurrenceProperty name="occurrence.recordedBy" title="Recorded by" occurrence="${occurrence}" />
                <to:occurrenceProperty name="event.eventDate" title="Event date" occurrence="${occurrence}" />
                <to:occurrenceProperty name="location.locality" title="Locality" occurrence="${occurrence}" />
            </div>
        </div>
        <div class="row-fluid">
            <div class="span12">
                <g:each in="${question.tags}" var="tag">
                    <div class="label label-info">${tag.tag}</div>
                </g:each>
                <small class="pull-right">OccurrenceId: ${question.occurrenceId}</small>
            </div>
        </div>
    </div>
</div>