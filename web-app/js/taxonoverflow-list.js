"use strict";

var taxonoverflow = function() {
    var facetsFilter = {};
    var searchUrl = '';
    var activePopoverTag = '';
    var counter;
    var imageServiceBaseUrl = "http://images.ala.org.au";

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
                $('#carousel').html($(this).find('.thumbnails'));
                var firstImage = $('#carousel .thumbnails .sp-thumbnail').length > 0 ? $('#carousel .thumbnails .sp-thumbnail').first().attr('img-id') : null;

                $('#imgGalleryModal').modal('show').on('shown.bs.modal', function (e) {
                    imgvwr.viewImage($("#imageViewer"), firstImage, {
                        imageServiceBaseUrl: imageServiceBaseUrl
                    });
                    $('#carousel').sliderPro({
                        width: $(window).width() - 100,
                        height: '100%',
                        fade: true,
                        arrows: false,
                        buttons: false,
                        fullScreen: false,
                        shuffle: false,
                        thumbnailArrows: true,
                        autoplay: false
                    });
                }).on('hidden.bs.modal', function (e) {
                    $('#carousel').sliderPro('destroy');
                });
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



