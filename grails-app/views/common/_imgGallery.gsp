
<div class="modal fade modal-fullscreen" id="imgGallery" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-body">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <p>One fine body…</p>
            </div>
            <div class="modal-footer">
                <div id="carousel" class="slider-pro">
                    <div class="sp-slides" style="display: none;">
                        <div class="sp-slide">
                            <img class="sp-thumbnail" src="${createLink(uri:'/vendor/img-gallery/images/small/1.jpg')}"/>
                        </div>
                        <div class="sp-slide">
                            <img class="sp-thumbnail" src="${createLink(uri:'/vendor/img-gallery/images/small/2.jpg')}"/>
                        </div>
                        <div class="sp-slide">
                            <img class="sp-thumbnail" src="${createLink(uri:'/vendor/img-gallery/images/small/3.jpg')}"/>
                        </div>
                        <div class="sp-slide">
                            <img class="sp-thumbnail" src="${createLink(uri:'/vendor/img-gallery/images/small/4.jpg')}"/>
                        </div>
                        <div class="sp-slide">
                            <img class="sp-thumbnail" src="${createLink(uri:'/vendor/img-gallery/images/small/5.jpg')}"/>
                        </div>
                        <div class="sp-slide">
                            <img class="sp-thumbnail" src="${createLink(uri:'/vendor/img-gallery/images/small/6.jpg')}"/>
                        </div>
                        <div class="sp-slide">
                            <img class="sp-thumbnail" src="${createLink(uri:'/vendor/img-gallery/images/small/7.jpg')}"/>
                        </div>
                        <div class="sp-slide">
                            <img class="sp-thumbnail" src="${createLink(uri:'/vendor/img-gallery/images/small/8.jpg')}"/>
                        </div>
                        <div class="sp-slide">
                            <img class="sp-thumbnail" src="${createLink(uri:'/vendor/img-gallery/images/small/9.jpg')}"/>
                        </div>
                        <div class="sp-slide">
                            <img class="sp-thumbnail" src="${createLink(uri:'/vendor/img-gallery/images/small/10.jpg')}"/>
                        </div>
                        <div class="sp-slide">
                            <img class="sp-thumbnail" src="${createLink(uri:'/vendor/img-gallery/images/small/11.jpg')}"/>
                        </div>
                        <div class="sp-slide">
                            <img class="sp-thumbnail" src="${createLink(uri:'/vendor/img-gallery/images/small/12.jpg')}"/>
                        </div>
                        <div class="sp-slide">
                            <img class="sp-thumbnail" src="${createLink(uri:'/vendor/img-gallery/images/small/13.jpg')}"/>
                        </div>
                        <div class="sp-slide">
                            <img class="sp-thumbnail" src="${createLink(uri:'/vendor/img-gallery/images/small/14.jpg')}"/>
                        </div>
                        <div class="sp-slide">
                            <img class="sp-thumbnail" src="${createLink(uri:'/vendor/img-gallery/images/small/15.jpg')}"/>
                        </div>
                        <div class="sp-slide">
                            <img class="sp-thumbnail" src="${createLink(uri:'/vendor/img-gallery/images/small/16.jpg')}"/>
                        </div>
                        <div class="sp-slide">
                            <img class="sp-thumbnail" src="${createLink(uri:'/vendor/img-gallery/images/small/17.jpg')}"/>
                        </div>
                        <div class="sp-slide">
                            <img class="sp-thumbnail" src="${createLink(uri:'/vendor/img-gallery/images/small/18.jpg')}"/>
                        </div>
                        <div class="sp-slide">
                            <img class="sp-thumbnail" src="${createLink(uri:'/vendor/img-gallery/images/small/19.jpg')}"/>
                        </div>
                        <div class="sp-slide">
                            <img class="sp-thumbnail" src="${createLink(uri:'/vendor/img-gallery/images/small/20.jpg')}"/>
                        </div>
                    </div>
                </div>
                <script type="text/javascript">
                    $(function() {
                        console.log("window width" + $(window).width());
                        $('#imgGallery').on('shown.bs.modal', function (e) {
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
                        });
                        $('#imgGallery').on('hidden.bs.modal', function (e) {
                            $('#carousel').sliderPro('destroy');
                        });
                    });
                </script>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div><!-- /.modal -->