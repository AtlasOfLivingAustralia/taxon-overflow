<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="tomain"/>
        <title>Welcome to Grails</title>

        <r:style type="text/css">

            #imageViewer {
                height: 400px;
            }

            %{--.image-thumb {--}%
                %{--height: 100px--}%
            %{--}--}%

        </r:style>

        <r:require module="viewer" />
        <r:require module="flexisel" />

        <r:script>

            var images = [];
            <g:each in="${imageIds}" var="imageId">
                images.push("${imageId}");
            </g:each>

            $(document).ready(function() {

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
            });

            $(window).load(function() {
                $("#mediaThumbs").flexisel({
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
                            visibleItems: 1
                        },
                        landscape: {
                            changePoint:640,
                            visibleItems: 2
                        },
                        tablet: {
                            changePoint:768,
                            visibleItems: 3
                        }
                    }
                });
            });

        </r:script>

    </head>
    <body class="content">
        Question ${question.id}

        <div class="row-fluid">
            <div class="span6">
                <to:occurrencePropertiesTable title="Location" section="location" names="locality, decimalLatitude, decimalLongitude" occurrence="${occurrence}" />
                <to:occurrencePropertiesTable title="Identification" section="classification" names="scientificName" occurrence="${occurrence}" />
            </div>
            <div class="span6">
                <div id="imageViewer"></div>
                <g:if test="${imageIds.size() > 1}">
                    <div style="margin-top: 10px">
                        ${imageIds.size()} images
                        <ul id="mediaThumbs">
                            <g:each in="${imageIds}" var="imageId">
                                <li imageId="${imageId}" ><img class="image-thumb" src="http://images.ala.org.au/image/proxyImageThumbnail?imageId=${imageId}" /></li>
                            </g:each>
                        </ul>
                    </div>
                </g:if>
            </div>
        </div>
    </body>
</html>
