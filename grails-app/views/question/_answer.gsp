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
                <g:set var="answerVoteTotal" value="${answerVoteTotals[answer]}"/>
                <p><span class="stat__number">${answerVoteTotal ?: 0}</span> votes</p>
            </div>
        </div>
    </div>
    <div class="panel-footer">
        <a class="btn btn-primary" href="${g.createLink(controller: 'dialog', action: 'addAnswerCommentDialog', id: answer.id)}"
           aa-refresh-zones="answerCommentDialogZone"
           aa-js-after="$('#answerCommentModalDialog').modal('show')">
            Add a comment
        </a>
        <div class="btn btn-group voting-group">
            <g:set var="userVote" value="${userVotes[answer]}"/>
            <g:set var="isUpVote" value="${userVote?.voteValue > 0}"/>
            <a class="btn btn-default thumbs ${isUpVote ? 'active' : ''}" href="${g.createLink(controller: 'webService', action: 'castVoteOnAnswer', params: [id: answer.id, dir: isUpVote ? 0 : 1 , userId: to.currentUserId()])}">
                <i class="fa ${isUpVote ? 'fa-thumbs-up' : 'fa-thumbs-o-up'}"></i>
            </a>
            <g:set var="isDownVote" value="${userVote?.voteValue && userVote?.voteValue < 0}"/>
            <a class="btn btn-default thumbs ${isDownVote ? 'active' : ''}" href="${g.createLink(controller: 'webService', action: 'castVoteOnAnswer', params: [id: answer.id, dir: isDownVote ? 0 : -1, userId: to.currentUserId()])}">
                <i class="fa ${isDownVote ? 'fa-thumbs-down' : 'fa-thumbs-o-down'}"></i>
        </a>
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
<aa:zone id="answerCommentDialogZone"></aa:zone>
<script>
    $(".thumbs").on('click', function(e) {
        e.preventDefault();
        $(this).find('i').removeClass(function (index, css) {
            return (css.match (/(^|\s)fa-thumbs-\S+/g) || []).join(' ');
        }).addClass('fa-cog fa-spin');
        $.get($(this).attr('href'), function(data){
            if (data.success) {
                $("#refreshAnswersLink").click();
            }
        })
    });
</script>