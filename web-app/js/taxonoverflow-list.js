"use strict";

var taxonoverflow = function() {
    var facetsFilter = {};
    var searchUrl = '';
    var activePopoverTag = '';
    var counter;
    var imageServiceBaseUrl = "http://images.ala.org.au";
    var devImageServiceBaseUrl = "http://images-dev.ala.org.au";

    var initEventHandlers = function() {
        $(document).on('click', "#btnQuestionSearch", function(e) {
            e.preventDefault();
            doSearch();
        });

        $(document).on('keydown', "#txtSearch", function(e) {
            if (e.keyCode == 13) {
                doSearch();
            }
        });

        $(document).on('click', '.tag-follow-button', function (e) {
            e.preventDefault();
            var response = tolib.doAjaxRequest($(this).attr('href'), {}, 'GET');
            response.done(function (data) {
                if (data.success) {
                    taxonoverflow.hideActivePopoverTag();
                    $("#refreshQuestionsListLink").click();
                    $("#refreshAggregatedTagsLink").click();

                }
            });
        });

        $(document).on("click", 'div.facets ul li span.label', function() {
            $(this).toggleClass('label-success');
            $(this).toggleClass('label-default');
            updateFacetsFilter();
        });

        $(document).on('click', '.question-thumb', function() {
            if ($(this).find('.sp-slide').length > 0 ) {
                $('#carousel').html($(this).find('.thumbnails').clone());
                var images = $('#carousel').find('.thumbnails > .sp-slide > .sp-thumbnail');
                var resolvedImageServiceBaseUrl = images && images.length > 0 && images.first().attr('src').toString().indexOf("images-dev.ala.org.au") >= 0 ? devImageServiceBaseUrl : imageServiceBaseUrl;
                var firstImageId = images && images.length > 0 ? images.first().attr('img-id') : null;

                if (firstImageId) {

                    var galleryWidget;

                    var customViewerOptions = {
                        imageServiceBaseUrl: resolvedImageServiceBaseUrl,
                        galleryOptions: {
                            enableGalleryMode: true,
                            closeControlContent: '<i class="fa fa-times" data-dismiss="modal" aria-label="Close" style="line-height:1.65;"></i>',
                            showFullScreenControls: true
                        }
                    };

                    imgvwr.removeCurrentImage();
                    imgvwr.viewImage($("#imageViewer"), firstImageId, $.extend(customViewerOptions, tolib.viewerOptions));

                    $('#imgGalleryModal').on('shown.bs.modal', function (e) {
                        galleryWidget = new GalleryWidget('carousel', {
                            width: $(window).width() - 100,
                            gotoThumbnail: function() {
                                imgvwr.removeCurrentImage();
                                var selectedImageId = $('#carousel').find('.sp-selected-thumbnail > img').attr('img-id');
                                imgvwr.viewImage($("#imageViewer"), selectedImageId, $.extend(customViewerOptions, tolib.viewerOptions));
                            }
                        });
                    });

                    $('#imgGalleryModal').on('hidden.bs.modal', function (e) {
                        imgvwr.removeCurrentImage();
                        galleryWidget.destroy();
                    });

                    $('#imgGalleryModal').modal('show');
                }
            }
        });
    };

    var updateFacetsFilter = function() {
        facetsFilter.tags = [];
        facetsFilter.types = [];
        $("#tagsFacet li span.label-success").each(function() {
            facetsFilter.tags.push($(this).text());
        });
        $("#typesFacet li span.label-success").each(function() {
            facetsFilter.types.push($(this).text());
        });
        doSearch();
    };

    var doSearch = function() {
        var q = $("#txtSearch").val();
        window.location.href = searchUrl + "&q=" + encodeURIComponent(q) + "&f.tags=" + facetsFilter.tags.join(',') + "&f.types=" + facetsFilter.types.join(',');;
    };



    return {
        counter: counter,

        init: function(options) {
            facetsFilter = {
                tags: [],
                types: []
            };

            searchUrl = options.searchUrl;
            imageServiceBaseUrl = options.imageServiceBaseUrl;

            initEventHandlers();
        },

        setActivePopoverTag: function(tagId) {
            activePopoverTag = tagId
        },

        showActivePopoverTag: function() {
            if (activePopoverTag) {
                $('#' + activePopoverTag).popover('show');
                $(".popover").on("mouseleave", function () {
                    $(this).popover('hide');
                    taxonoverflow.clearActivePopoverTag();
                });
            }
        },

        hideActivePopoverTag: function() {
            if (activePopoverTag) {
                $('#' + activePopoverTag).popover('hide');
            }
        },

        clearActivePopoverTag: function() {
            activePopoverTag: null;
        },

        enableTagPopovers: function() {
            $('.follow-tag').popover({}).on("mouseenter", function () {
                var _this = this;
                taxonoverflow.setActivePopoverTag($(this).attr('id'));
                clearTimeout(taxonoverflow.counter);
                taxonoverflow.counter = setTimeout(function () {
                    $(_this).popover("show");
                    $(".popover").on("mouseleave", function () {
                        $(_this).popover('hide');
                        taxonoverflow.clearActivePopoverTag();
                    });
                }, 400);
            }).on("mouseleave", function () {
                var _this = this;
                setTimeout(function () {
                    if (!$(".popover:hover").length) {
                        $(_this).popover("hide");
                        taxonoverflow.clearActivePopoverTag();
                    }
                }, 300);
            });

            taxonoverflow.showActivePopoverTag();
        }

    };
}();



