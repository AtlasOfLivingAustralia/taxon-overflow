<%@ page import="com.github.rjeschke.txtmark.Processor" %>
<g:if test="${answer.comments}">
    <section class="comment-list">
        <g:each in="${answer.comments}" var="comment">
            <div class="row">
                <div class="col-md-2 col-sm-2 hidden-xs">
                   <figure class="thumbnail">
                    <avatar:gravatar email="${to.userName(user: comment.user)}" class="img-responsive" alt="My Avatar" size="55" gravatarRating="G" defaultGravatarUrl="identicon"/>
                    </figure>
                </div>

                <div class="col-md-10 col-sm-10 comment-padding">
                    <div class="panel panel-default arrow left">
                        <div class="panel-body">
                            <header class="text-left">
                                <div class="pull-left">
                                    <div class="comment-user"><i class="fa fa-user"></i> <span class="comment-author"><to:userDisplayName user="${comment.user}"/></span></div>
                                    <time class="comment-date" datetime="16-12-2014 01:05"><i class="fa fa-clock-o"></i> <prettytime:display date="${comment.dateCreated}"/></time>
                                </div>
                                <to:ifCanEditComment comment="${comment}">
                                    <div class="pull-right">
                                        <a class="removeAnswerCommentButton" title="Delete answer comment" href="${g.createLink(controller: 'webService', action: 'deleteAnswerComment')}" comment-id="${comment.id}">
                                            <i class="fa fa-trash" ></i>
                                        </a>
                                    </div>
                                </to:ifCanEditComment>
                            </header>
                            <div class="clearfix"></div>
                            <div class="comment-post pull-left">
                                ${raw(Processor.process(comment.comment))}
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </g:each>
    </section>
</g:if>