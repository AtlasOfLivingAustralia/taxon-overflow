<aa:zone id="answersZone">
    <a aa-refresh-zones="answerZone" id="refreshAnswersLink" href="${g.createLink(controller: 'question', action: 'answers', id: question.id)}" class="hidden">Refresh</a>
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

    <div class="panel panel-success">
        <div class="panel-heading heading-underlined"><h4 class="heading-underlined">Accepted answer</h4></div>
        <div class="panel-body">
            <div class="row">
                <div class="col-md-8">
                    <div class="padding-bottom-1">
                        <h4>Homo sapiens: Human, Man</h4>
                        <small>Identified by <a href="#">Dave Martin</a> 2 days ago</small>
                    </div>
                </div>
                <div class="col-md-4">
                    <p><span class="stat__number">23</span> votes</p>
                </div>
            </div>
        </div>
        <div class="panel-footer">
            <a class="btn btn-primary" href="#comment" data-toggle="modal">Add a comment</a>
            <div class="btn btn-group">
                <a class="btn btn-default" href="#"><i class="fa fa-thumbs-o-up"></i></a>
                <a class="btn btn-default" href="#"><i class="fa fa-thumbs-o-down"></i></a>
            </div>

        </div>
        <div class="panel-footer comments">

            <div class="row">
                <div class="comment public_comment">
                    <div class="comment-wrapper ">
                        <div class="body">
                            <div class="col-md-12">
                                <div class="ident-question heading-underlined">I have found this. What is it?</div>
                                <div class="contrib-time">27 minutes ago by <a href="#">Adam Atteia</a></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <div class="panel panel-default">
        <div class="panel-heading"><h4 class="heading-underlined">Closest answer</h4></div>
        <div class="panel-body">
            <div class="row">
                <div class="col-md-8">
                    <div class="padding-bottom-1">
                        <h4>Homo sapiens: Servant, Public</h4>
                        <small>Identified by <a href="#">Tony Abbott</a> 3 days ago</small>
                    </div>
                </div>
                <div class="col-md-4">
                    <p><span class="stat__number">7</span> votes</p>
                </div>
            </div>
        </div>
        <div class="panel-footer">
            <a class="btn btn-primary" href="#comment" data-toggle="modal">Add a comment</a>
            <div class="btn btn-group">
                <a class="btn btn-default" href="#"><i class="fa fa-thumbs-o-up"></i></a>
                <a class="btn btn-default" href="#"><i class="fa fa-thumbs-o-down"></i></a>
            </div>
        </div>
        <div class="panel-footer comments">

            <div class="row">
                <div class="comment public_comment">
                    <div class="comment-wrapper push">
                        <div class="body">
                            <div class="col-md-12">
                                <div class="ident-question heading-underlined"><a href="#">@Adam Atteia</a> That's definitely not right.</div>
                                <div class="contrib-time">2 minutes ago by <a href="#">Trevor Phillips</a></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="comment public_comment">
                    <div class="comment-wrapper push">
                        <div class="body">
                            <div class="col-md-12">
                                <div class="ident-question heading-underlined"><a href="#">@Pikachu</a> I don't think that's right ...</div>
                                <div class="contrib-time">8 minutes ago by <a href="#">Adam Atteia</a></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="comment public_comment">
                    <div class="comment-wrapper push">
                        <div class="body">
                            <div class="col-md-12">
                                <div class="ident-question heading-underlined">This is a rare form of the silver pokemon found in the dark green patch of the northern maps of India.</div>
                                <div class="contrib-time">27 minutes ago by <a href="#">Pikachu (I love you)</a></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <div class="panel panel-default">
        <div class="panel-heading"><h4 class="heading-underlined">Answer</h4></div>
        <div class="panel-body">
            <div class="row">
                <div class="col-md-8">
                    <div class="padding-bottom-1">
                        <h4>Homo sapiens: Lawyer, Crimefighter</h4>
                        <small>Identified by <a href="#">Daredevil, the Man Without Fear</a> 3 days ago</small>
                    </div>
                </div>
                <div class="col-md-4">
                    <p><span class="stat__number">4</span> votes</p>
                </div>
            </div>
        </div>
        <div class="panel-footer">
            <a class="btn btn-primary" href="#comment" data-toggle="modal">Add a comment</a>
            <div class="btn btn-group">
                <a class="btn btn-default" href="#"><i class="fa fa-thumbs-o-up"></i></a>
                <a class="btn btn-default" href="#"><i class="fa fa-thumbs-o-down"></i></a>
            </div>
        </div>
    </div>
</aa:zone>