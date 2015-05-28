"use strict";

$(function() {
    if ($.cookie('taxonoverflow-alertInfo')) {
        JSON.parse($.cookie('taxonoverflow-alertInfo')).forEach(function(id) {
            $('#' + id).hide();
        });
    }

    $(".info-alert-close-btn").on('click', function() {
        if (!$.cookie('taxonoverflow-alertInfo')) {
            $.cookie('taxonoverflow-alertInfo', JSON.stringify([]), {expires: 365 * 1, path: '/'});
        }
        var alertInfoList = JSON.parse($.cookie('taxonoverflow-alertInfo'));
        alertInfoList.push($(this).attr('info-alert'));
        $.cookie('taxonoverflow-alertInfo', JSON.stringify(alertInfoList), {expires: 365 * 1, path: '/'});
    });

    // Initialize tooltips for disable buttons or linkss
    $('body').tooltip({
        selector: '.disable-btn-tooltip',
        container: 'body',
        title: 'Log in to enable this feature'
    });

    $(document).on('keyup', '.markdown-field .textarea-edit > textarea', function() {
        $(this).parent().next().html(marked($(this).val()));
    });

    $(document).on('click', '.markdown-field .toggle-markdown a', function(e){
        e.preventDefault();
        $('.markdown-field .toggle-markdown li').toggleClass('active');
        $(this).closest('.markdown-field').find('.textarea-edit').toggleClass('hidden');
        $(this).closest('.markdown-field').find('.textarea-preview').toggleClass('hidden');
    });

    // Keep session alive every 10 minutes
    $(function() { window.setInterval("keepSessionAlive()", 600000); });
});

function keepSessionAlive() {
    $.get(tolib.keepSessionAliveUrl);
}

var tolib = {};

(function(lib) {

    lib.viewerOptions = {
        addDownloadButton: false,
        addDrawer: false,
        addSubImageToggle: false,
        addCalibration: false,
        addImageInfo: true
    };

    lib.keepSessionAliveUrl = '';

    lib.keepSessionAlive = function(){
        $.get(lib.keepSessionAliveUrl);
    };

    lib.areYouSureOptions = {};

    lib.areYouSure = function(options) {

        if (!options.title) {
            options.title = "Are you sure?"
        }

        if (!options.message) {
            options.message = options.title;
        }

        var modalOptions = {
            url: TAXON_OVERFLOW_CONF.areYouSureUrl + "?message=" + encodeURIComponent(options.message),
            title: options.title
        };

        lib.areYouSureOptions.affirmativeAction = options.affirmativeAction;
        lib.areYouSureOptions.negativeAction = options.negativeAction;

        lib.showModal(modalOptions);
    };

    lib.pleaseWait = function(message, ajaxUrl, resultHandler) {

        var modalOptions = {
            url: TAXON_OVERFLOW_CONF.pleaseWaitUrl + "?message=" + encodeURIComponent(message),
            title: "Please wait...",
            onShown: function() {
                $.ajax(ajaxUrl).done(function(result) {
                    if (resultHandler) {
                        resultHandler(result);
                    }
                    lib.hideModal();
                });
            }
        };

        lib.showModal(modalOptions);

    };

    lib.htmlEscape = function(str) {
        return String(str)
            .replace(/&/g, '&amp;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;');
    };

    lib.htmlUnescape = function(value) {
        return String(value)
            .replace(/&quot;/g, '"')
            .replace(/&#39;/g, "'")
            .replace(/&lt;/g, '<')
            .replace(/&gt;/g, '>')
            .replace(/&amp;/g, '&');
    };

    lib.showSpinner = function(message) {
        var spinner = $(".spinner");
        if (message) {
            spinner.attr("title", message);
        } else {
            spinner.attr("title", "");
        }
        spinner.css("display", "block");
    };

    lib.hideSpinner = function() {
        var spinner = $(".spinner");
        spinner.css("display", "none");
    };

    lib.doJsonPost = function(url, data) {
        var dataStr = JSON.stringify(data);
        return $.ajax({
            type:'POST',
            url: url,
            contentType:'application/json',
            data: dataStr
        });
    };

    lib.doAjaxRequest = function(url, data, method) {
        var dataStr = JSON.stringify(data);
        return $.ajax({
            type: method ? method : 'POST',
            url: url,
            contentType:'application/json',
            data: dataStr
        });
    };

    lib.serializeFormJSON = function(form) {
        var o = {};
        var a = form.serializeArray();
        $.each(a, function() {
            if (o[this.name]) {
                if (!o[this.name].push) {
                    o[this.name] = [o[this.name]];
                }
                o[this.name].push(this.value || '');
            } else {
                o[this.name] = this.value || '';
            }
        });
        return o;
    };

    lib.bindTooltips = function(selector, width) {

        if (!selector) {
            selector = "a.fieldHelp";
        }
        if (!width) {
            width = 300;
        }
        // Context sensitive help popups
        $(selector).each(function() {


            var tooltipPosition = $(this).attr("tooltipPosition");
            if (!tooltipPosition) {
                tooltipPosition = "bottomRight";
            }

            var targetPosition = $(this).attr("targetPosition");
            if (!targetPosition) {
                targetPosition = "topMiddle";
            }
            var tipPosition = $(this).attr("tipPosition");
            if (!tipPosition) {
                tipPosition = "bottomRight";
            }

            var elemWidth = $(this).attr("width");
            if (elemWidth) {
                width = elemWidth;
            }

            $(this).qtip({
                tip: true,
                position: {
                    corner: {
                        target: targetPosition,
                        tooltip: tooltipPosition
                    }
                },
                style: {
                    width: width,
                    padding: 8,
                    background: 'white', //'#f0f0f0',
                    color: 'black',
                    textAlign: 'left',
                    border: {
                        width: 4,
                        radius: 5,
                        color: '#E66542'// '#E66542' '#DD3102'
                    },
                    tip: tipPosition,
                    name: 'light' // Inherit the rest of the attributes from the preset light style
                }
            }).bind('click', function(e){ e.preventDefault(); return false; });

        });
    };

})(tolib);




