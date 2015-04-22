"use strict";

var taxonoverflow = function() {
    var facetsFilter = {};
    var searchUrl = '';

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

        $("div.facets ul li span.label").on("click", function() {
            $(this).toggleClass('label-success');
            $(this).toggleClass('label-default');
            updateFacetsFilter();
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
        window.location.href = searchUrl + "&f.tags=" + facetsFilter.tags.join(',') + "&f.types=" + facetsFilter.types.join(',');;
    };

    return {
        init: function(options) {
            facetsFilter = {
                tags: [],
                types: []
            };

            searchUrl = options.searchUrl;

            initEventHandlers();
        }
    };
}();



