"use strict";

var taxonoverflow = function() {
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
        $("#media-thumb-list").flexisel({
            visibleItems: 4,
            animationSpeed: 200,
            autoPlay: false,
            autoPlaySpeed: 3000,
            pauseOnHover: true,
            clone:false,
            enableResponsiveBreakpoints: true,
            responsiveBreakpoints: {
                portrait: {
                    changePoint:480,
                    visibleItems: 2
                },
                landscape: {
                    changePoint:640,
                    visibleItems: 3
                },
                tablet: {
                    changePoint:768,
                    visibleItems: 4
                }
            }
        });

        if (images.length > 0) {
            imgvwr.viewImage($("#imageViewer"), images[0], {})
        }

        $(".image-thumb").click(function(e) {
            e.preventDefault();
            var imageId = $(this).closest("[imageId]").attr("imageId");
            if (imageId) {
                imgvwr.viewImage($("#imageViewer"), imageId, {})
            }
        });
    };

    return {
        init: function(options) {
            images = options.images;
            followURL = options.followURL;
            unfollowURL = options.unfollowURL;

            initEventHandlers();
            initImagesGallery()
        }
    };
}();