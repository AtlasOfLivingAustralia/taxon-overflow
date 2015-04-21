<r:script>
    /**
     * Extend BS popover to keep popover active on hover when mouse is over popover
     * Taken from http://stackoverflow.com/a/19804807/249327
     */
    (function($) {
        var oldHide = $.fn.popover.Constructor.prototype.hide;
        $.fn.popover.Constructor.prototype.hide = function() {
            if (this.options.trigger === "hover" && this.tip().is(":hover")) {
                var that = this;
                // try again after what would have been the delay
                setTimeout(function() {
                    return that.hide.call(that, arguments);
                }, that.options.delay.hide);
                return;
            }
            oldHide.call(this, arguments);
        };
    })(jQuery);

    $(document).ready(function () {

        // get list of followed tags for user: ${to.currentUserId()}
    var userId = "${to.currentUserId()}";
        if (userId) {
            $.get("${g.createLink(uri:'/ws/tag/following')}" + '/' + userId)
            .done(function(data) {
                if (data.success && data.result) {
                    window.followedTags = data.result;
                } else {
                    alert("Error: " + data.message);
                }
            })
            .fail(function( jqXHR, textStatus, errorThrown ) {
                alert("Error: " + textStatus + " - " + errorThrown);
            })
            .always(function() {
                initTagPopovers(followedTags);
            });
        }

        $('#tagsFacet').on('click', '.followTag', function(e) {
            e.preventDefault();
            var tag = $(this).data('tag');
            var id = $(this).data('id');
            var tagIsSubscribed = (jQuery.inArray(tag, window.followedTags) > -1); // bool
            var action = (tagIsSubscribed) ? 'unfollow' : 'follow';
            $.get("${g.createLink(uri:'/ws/tag/')}" + action + '/' + tag)
            .done(function(data) {
                if (data.success) {
                    if (!tagIsSubscribed) {
                        window.followedTags.push(tag); //update JSON array
                    } else {
                        window.followedTags.splice(jQuery.inArray(tag, window.followedTags), 1); //update JSON array
                    }

                    var popover = $('#tag_' + id).data('popover');
                    popover.options.content = setPopoverContent(tag, id);
                    popover.$tip.addClass(popover.options.placement);
                    $('#tag_' + id).popover('show');
                    initTagPopovers();
                } else {
                    alert('Error. Your settings were NOT saved. ' + data.message);
                }
            })
            .fail(function( jqXHR, textStatus, errorThrown ) {
                alert("Error: " + textStatus + " - " + errorThrown);
            });
        });

    });

    function initTagPopovers() {
        $('.label.tag').each(function(i, el) {
            var tag = $(this).text();
            var popover = $('#tag_' + i).data('popover');

            if (popover && popover.$tip) {
                popover.options.content = setPopoverContent(tag, i);
                popover.$tip.addClass(popover.options.placement);
            } else {
                $(this).attr('id','tag_' + i); // add unique ID
                $(this).popover({
                    placement: 'bottom',
                    html: true,
                    trigger: 'hover',
                    container: '#tagsFacet',
                    delay: 500,
                    content: setPopoverContent(tag, i)
                });
                $(this).popover('show'); // keep these - they allow content to be changed
                $(this).popover('hide'); // keep these - they allow content to be changed
            }
        });
    }

    function setPopoverContent(tag, i) {
        var isSubscribed = (jQuery.inArray(tag, window.followedTags) > -1); // bool
        var subscribeStatus = (isSubscribed) ? 'unsubscribe' : 'subscribe';
        var html = '<a href="#" class="followTag" data-id="' + i
                 + '" data-tag="' + tag
                 + '"><i class="fa following fa-lg '
                 + ((isSubscribed) ? 'fa-star' : 'fa-star-o') + '"></i> '
+ subscribeStatus + '</a>';
        return html;
    }
</r:script>
<h3 class="font-xxsmall">Filter by type</h3>
<ul id="tagsFacet">
    <g:each in="${tags}" var="tag">
        <g:set var="selectedTags" value="${params.f?.tags?: []}"/>
        <li><span class="label ${selectedTags.contains(tag.label) ? 'label-success' : 'label-default'} tag tag_${tag.label}">${tag.label}</span> × ${tag.count}</li>
    </g:each>
</ul>