<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="tomain"/>
        <title>Welcome to Grails</title>

        <r:style type="text/css">

            #imageViewer {
                height: 250px;
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
            });

            $(window).load(function() {
                $("#mediaThumbs").flexisel({
                    visibleItems: 3,
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

            </div>
            <div class="span6">
                <div id="imageViewer"></div>
                <div style="margin-top: 10px">
                    <ul id="mediaThumbs">
                        <g:each in="${imageIds}" var="imageId">
                            <li><img class="image-thumb" src="http://images.ala.org.au/image/proxyImageThumbnail?imageId=${imageId}" /></li>
                        </g:each>
                    </ul>
                </div>
            </div>
        </div>
    </body>
</html>
