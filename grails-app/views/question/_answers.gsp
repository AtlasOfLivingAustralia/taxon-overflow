<aa:zone id="answersZone">
    <a aa-refresh-zones="answersZone" id="refreshAnswersLink" href="${g.createLink(controller: 'question', action: 'answers', id: question.id)}" class="hidden">Refresh</a>
    <div class="padding-bottom-1">
        <!-- Alert page information -->
        <div class="alert alert-info alert-dismissible" role="alert">
            <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <strong>Add your identification answers.</strong>
            Add an answer to the topic question or add comments to existing answers.
        </div>
        <!-- End alert page information -->
    </div>
    <div class="btn-group padding-bottom-1">
        <!-- <p>Help the ALA by adding an answer or comments to existing answers.</p> -->
        <a class="btn btn-primary btn-lg" href="${g.createLink(controller: 'dialog', action: 'addAnswerDialog', id: question.id)}"
           aa-refresh-zones="answerDialogZone"
           aa-js-after="$('#answerModalDialog').modal('show')">
            Add an identification
        </a>
        <aa:zone id="answerDialogZone"></aa:zone>
    </div>

    <g:if test="${!answers || answers.size == 0}">
        <p>No answers posted yet.</p>
    </g:if>
    <g:each in="${answers}" var="answer">
        <g:set var="answerProperties" value="${new groovy.json.JsonSlurper().parseText(answer.darwinCore)}"/>
        <div class="panel ${answer.accepted ? 'panel-success' : 'panel-default'} answer">
            <div class="panel-heading"><h4 class="heading-underlined">${answer.accepted ? 'Accepted answer' : 'Answer'}</h4></div>
            <div class="panel-body">
                <div class="row">
                    <div class="col-md-8">
                        <div class="padding-bottom-1">
                            <g:if test="${answerProperties.taxonConceptID}">
                                <a href="http://bie.ala.org.au/species/${answerProperties.taxonConceptID}">
                            </g:if>
                                <h4>${answerProperties.commonName && answerProperties.scientificName ? "${answerProperties.scientificName} : ${answerProperties.commonName}" : "${answerProperties.scientificName}"}</h4>
                            <g:if test="${answerProperties.taxonConceptID}">
                                </a>
                            </g:if>
                            <small>Posted by <to:userDisplayName user="${answer.user}"/> <prettytime:display date="${answer.dateCreated}"/></small>
                        </div>
                    </div>
                    <div class="col-md-offset-1 col-md-3 votes">
                        <p><span class="stat__number">${answer.votes ? answer.votes.size() : 0}</span> votes</p>
                    </div>
                </div>
            </div>
            <div class="panel-footer">
                <a class="btn btn-primary" href="${g.createLink(controller: 'dialog', action: 'addAnswerCommentDialog', id: answer.id)}"
                   aa-refresh-zones="answerCommentDialogZone"
                   aa-js-after="$('#answerCommentModalDialog').modal('show')">
                    Add a comment
                </a>
                <div class="btn btn-group">
                    <a class="btn btn-default" href="#"><i class="fa fa-thumbs-o-up"></i></a>
                    <a class="btn btn-default" href="#"><i class="fa fa-thumbs-o-down"></i></a>
                </div>
            </div>
            <div class="panel-footer comments">
                <g:each in="${answer.comments}" var="comment">
                <div class="row">
                    <div class="comment public_comment">
                        <div class="comment-wrapper push">
                            <div class="body">
                                <div class="col-md-12">
                                    <div class="ident-question heading-underlined">${comment.comment}</div>
                                    <div class="contrib-time"><prettytime:display date="${comment.dateCreated}"/> by <to:userDisplayName user="${comment.user}"/></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                </g:each>
            </div>
        </div>
    </g:each>
</aa:zone>
<aa:zone id="answerCommentDialogZone"></aa:zone>