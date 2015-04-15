<div id="tags-group" class="btn-group">
    <p class="font-xxsmall">Tags:
    <g:each in="${question.tags}" var="tag">
        <span class="label label-primary">${tag.tag}<to:ifCanEditQuestion question="${question}">&nbsp;
            <a class="btnRemoveTag" href="${g.createLink(controller: 'webService', action: 'removeTagFromQuestion')}" tag="${tag.tag}"><i class="fa fa-remove"></i></a></to:ifCanEditQuestion>
        </span>
    </g:each>
    </p>
    <a aa-refresh-zones="tagsZone" href="${g.createLink(action:'questionTagsFragment', id: question.id)}" id="refreshTagsLink" class="hidden"></a>
</div>

<script>
    $('.btnRemoveTag').on('click', function(e) {
        e.preventDefault();
        var params = {
            'questionId': '${question.id}',
            'tag': $(this).attr('tag')
        };
        var url = $(this).attr('href');
        bootbox.confirm("Are you sure you want to delete the tag \"<strong>" + $(this).attr('tag') + "</strong>\"?", function(result){
            if (result) {
                var response = tolib.doAjaxRequest(url, params, 'DELETE');
                response.done(function(data) {
                    if (data.success) {
                        $("#refreshTagsLink").click();
                    } else {
                        bootbox.alert(data.message);
                    }
                });
            }
        });
    });
</script>
