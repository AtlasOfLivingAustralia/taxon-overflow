<style>

    .btnRemoveTag, .btnRemoveTag:visited {
        color: white;
        border: 1px solid transparent;
    }

    .btnRemoveTag:hover {
        border-radius: 3px;
        color: orangered;
    }

</style>
<g:each in="${question.tags}" var="tag">
    <div class="label label-info">${tag.tag}<to:ifCanEditQuestion question="${question}">&nbsp;<a class="btnRemoveTag" href="#" tag="${tag.tag}"><i class="fa fa-remove"></i></a></to:ifCanEditQuestion></div>
</g:each>
<to:ifCanEditQuestion question="${question}">
    <a href="#" id="btnSaveTag" class="label"><i class="fa fa-plus"></i>&nbsp;Add tag</a>
</to:ifCanEditQuestion>

<script>

    $("#btnSaveTag").click(function(e) {
        e.preventDefault();
        tolib.showModal( {
            url: "${createLink(controller:'dialog', action:'addQuestionTagFragment', params:[questionId: question.id])}",
            title: "",
            hideHeader: true,
            onClose: function() {
                if (renderAnswers instanceof Function) {
                    renderTags();
                }
            }
        });
    });

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
