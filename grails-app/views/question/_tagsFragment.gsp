<div id="tags-group" class="btn-group">
    <p class="font-xxsmall">Tags:
    <g:each in="${question.tags}" var="tag">
        <span class="label label-primary">${tag.tag}<to:ifCanEditQuestion question="${question}">&nbsp;<a class="btnRemoveTag" href="#" tag="${tag.tag}"><i class="fa fa-remove"></i></a></to:ifCanEditQuestion></span>
    </g:each>
    </p>
</div>

<script>

    $(".btnRemoveTag").click(function(e) {
        e.preventDefault();
        var tag = $(this).attr("tag");
        var data = {
            questionId: ${question.id},
            tag: tag
        };
        tolib.doJsonPost("${createLink(controller:'webService', action:'removeTagFromQuestion')}", data).done(function(response) {
            if (renderAnswers instanceof Function) {
                renderTags();
            }
        });
    });

</script>
