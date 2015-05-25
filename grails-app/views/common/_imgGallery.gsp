
<div class="modal fade modal-fullscreen" id="imgGallery" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-body">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <p>One fine body…</p>
            </div>
            <div class="modal-footer">
                <ul id="carousel" class="elastislide-list">
                    <li><a href="#"><img src="${createLink(uri:'/vendor/img-gallery/images/small/1.jpg')}" alt="image01" /></a></li>
                    <li><a href="#"><img src="${createLink(uri:'/vendor/img-gallery/images/small/2.jpg')}" alt="image02" /></a></li>
                    <li><a href="#"><img src="${createLink(uri:'/vendor/img-gallery/images/small/3.jpg')}" alt="image03" /></a></li>
                    <li><a href="#"><img src="${createLink(uri:'/vendor/img-gallery/images/small/4.jpg')}" alt="image04" /></a></li>
                    <li><a href="#"><img src="${createLink(uri:'/vendor/img-gallery/images/small/5.jpg')}" alt="image05" /></a></li>
                    <li><a href="#"><img src="${createLink(uri:'/vendor/img-gallery/images/small/6.jpg')}" alt="image06" /></a></li>
                    <li><a href="#"><img src="${createLink(uri:'/vendor/img-gallery/images/small/7.jpg')}" alt="image07" /></a></li>
                    <li><a href="#"><img src="${createLink(uri:'/vendor/img-gallery/images/small/8.jpg')}" alt="image08" /></a></li>
                    <li><a href="#"><img src="${createLink(uri:'/vendor/img-gallery/images/small/9.jpg')}" alt="image09" /></a></li>
                    <li><a href="#"><img src="${createLink(uri:'/vendor/img-gallery/images/small/10.jpg')}" alt="image10" /></a></li>
                    <li><a href="#"><img src="${createLink(uri:'/vendor/img-gallery/images/small/11.jpg')}" alt="image11" /></a></li>
                    <li><a href="#"><img src="${createLink(uri:'/vendor/img-gallery/images/small/12.jpg')}" alt="image12" /></a></li>
                    <li><a href="#"><img src="${createLink(uri:'/vendor/img-gallery/images/small/13.jpg')}" alt="image13" /></a></li>
                    <li><a href="#"><img src="${createLink(uri:'/vendor/img-gallery/images/small/14.jpg')}" alt="image14" /></a></li>
                    <li><a href="#"><img src="${createLink(uri:'/vendor/img-gallery/images/small/15.jpg')}" alt="image15" /></a></li>
                    <li><a href="#"><img src="${createLink(uri:'/vendor/img-gallery/images/small/16.jpg')}" alt="image16" /></a></li>
                    <li><a href="#"><img src="${createLink(uri:'/vendor/img-gallery/images/small/17.jpg')}" alt="image17" /></a></li>
                    <li><a href="#"><img src="${createLink(uri:'/vendor/img-gallery/images/small/18.jpg')}" alt="image18" /></a></li>
                    <li><a href="#"><img src="${createLink(uri:'/vendor/img-gallery/images/small/19.jpg')}" alt="image19" /></a></li>
                    <li><a href="#"><img src="${createLink(uri:'/vendor/img-gallery/images/small/20.jpg')}" alt="image20" /></a></li>
                </ul>
                <script type="text/javascript">
                    $(function() {
                        $('#imgGallery').on('shown.bs.modal', function (e) {
                            $('#carousel').elastislide();
                        });

                    });
                </script>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div><!-- /.modal -->