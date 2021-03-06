"use strict";

var taxonoverflow = function() {
    var imageServiceBaseUrl = "http://images.ala.org.au";
    var images = [];
    var followURL, unfollowURL;

    var initEventHandlers = function() {

        $(document).on('click', '#followQuestionButton', function() {
            $(this).find('i').removeClass('fa-star fa-star-o').addClass('fa-cog fa-spin');

            $.ajax({
                url: $(this).hasClass('active') ? unfollowURL : followURL,
                dataType: "json",
                success: function(data) {
                    $('#refreshFollowingZoneLink').click();
                }
            });
        });

        $(document).on("click", ".togglePlaceholder", function() {
            if (!$(this).hasClass("active")) {
                $(".togglePlaceholder").each(function() {
                    $(this).toggleClass("active");
                });
                $(".placeholder").each(function() {
                    $(this).toggleClass("hidden");
                });
            }

            // This is needed to refresh the map when it is actually shown so it fits the available size
            if(!$("#map").hasClass("hidden")) {
                map.invalidateSize();
            }
        });
    };

    var initImagesGallery = function() {
        if (images.length > 0) {

            var customViewerOptions = {
                imageServiceBaseUrl: imageServiceBaseUrl,
                galleryOptions: {
                    enableGalleryMode: true,
                    showFullScreenControls: true
                }
            };

            new GalleryWidget('carousel', {
                gotoThumbnail: function() {
                    imgvwr.removeCurrentImage();
                    var selectedImageId = $('#carousel').find('.sp-selected-thumbnail > img').attr('img-id');
                    imgvwr.viewImage($("#imageViewer"), selectedImageId, $.extend(customViewerOptions, tolib.viewerOptions));
                }
            });

            imgvwr.viewImage($("#imageViewer"), images[0], $.extend(customViewerOptions, tolib.viewerOptions));
        }
    };

    return {
        init: function(options) {
            imageServiceBaseUrl = options.imageServiceBaseUrl;
            images = options.images;
            followURL = options.followURL;
            unfollowURL = options.unfollowURL;

            initEventHandlers();
            initImagesGallery()
        }
    };
}();