<g:set var="questionUrl" value="${createLink(controller:'question', action:'view', id: question.id)}" />
<div class="row-fluid" style="margin-top: 10px">
    <div class="span4 question-meta-panel">
        <a href="${questionUrl}">

            <div class="row-fluid">
                <div class="span3 answer-count-div">
                    <g:set var="answerCount" value="${question.answers?.size()}" />
                    <span class="question-answer-count ${acceptedAnswer ? 'has-accepted-answer' : ''}">${answerCount}</span>
                    <br />
                    ${answerCount == 1 ? 'answer' : 'answers'}
                </div>
                <div class="span3 view-count-div">
                    <span class="question-view-count">${question.views?.size()}</span>
                    <br />
                    views
                </div>
                <div class="span6 view-count-div">
                    <small style="text-align: center">
                        <g:formatDate date="${question.dateCreated}" format="yyyy-MM-dd HH:mm:ss" />
                        <br />
                        <to:userDisplayName user="${question.user}" />
                    </small>
                </div>
            </div>

            <div class="row-fluid" style="margin-top: 30px; border-top: 1px dotted #dddddd">
                <div class="span12">
                    <g:each in="${question.tags}" var="tag">
                        <div class="label label-info">${tag.tag}</div>
                    </g:each>
                </div>
            </div>


            %{--<div class="row-fluid">--}%
                %{--<g:if test="${acceptedAnswer}" >--}%
                    %{--<div class="span12"  style="text-align: center">--}%
                        %{--<span class="accepted-answer-text">${acceptedAnswer.scientificName}</span>--}%
                    %{--</div>--}%
                %{--</g:if>--}%
            %{--</div>--}%

        </a>
    </div>
    <div class="span2" style="text-align: center">
        <g:if test="${imageInfo}">
            <a href="${questionUrl}">
                <img class="question-thumb" src="${imageInfo[0].squareThumbUrl}_darkGray" />
            </a>
            <g:if test="${imageInfo.size() > 1}">
                <br/>
                <small>${imageInfo.size()} images</small>
            </g:if>
        </g:if>
    </div>
    <div class="span6">
        <div class="row-fluid">
            <div class="span12">
                <to:occurrenceProperty name="occurrence.recordedBy" title="Recorded by" occurrence="${occurrence}" />
                <to:occurrenceProperty name="event.eventDate" title="Event date" occurrence="${occurrence}" />
                <to:occurrenceProperty name="location.locality" title="Locality" occurrence="${occurrence}" />
            </div>
        </div>
    </div>
</div>