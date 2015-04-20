<g:if test="${answer.comments}">
    <div class="panel-footer answer-comments">
        <g:each in="${answer.comments}" var="comment">
            <div class="row">
                <div class="comment public_comment">
                    <div class="comment-wrapper ">
                        <div class="body">
                            <div class="col-md-10">
                                <div class="ident-question">${comment.comment}</div>
                                <div class="contrib-time"><prettytime:display date="${comment.dateCreated}"/> by <to:userDisplayName user="${comment.user}"/></div>
                            </div>
                            <div class="col-md-2">
                                <ul class="list-inline pull-right">
                                    <to:ifCanEditComment comment="${comment}">
                                        <li class=" font-xsmall">
                                            <a class="removeAnswerCommentButton" href="${g.createLink(controller: 'webService', action: 'deleteAnswerComment')}" comment-id="${comment.id}">
                                                <i class="fa fa-trash" title="Delete answer comment"></i>
                                            </a>
                                        </li>
                                    </to:ifCanEditComment>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </g:each>
    </div>
</g:if>