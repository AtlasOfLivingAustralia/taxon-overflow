var taxonoverflow = {
    facetsFilter: {},
    searchUrl: ''

};

taxonoverflow.init = function(options) {
    taxonoverflow.facetsFilter = {
        tags: [],
        types: []
    };

    taxonoverflow.searchUrl = options.searchUrl

    taxonoverflow.initEventHandlers();
};

taxonoverflow.initEventHandlers = function() {
    $(document).on('click', "#btnQuestionSearch", function(e) {
        e.preventDefault();
        taxonoverflow.doSearch();
    });

    $(document).on('keydown', "#txtSearch", function(e) {
        if (e.keyCode == 13) {
            taxonoverflow.doSearch();
        }
    });

    $("div.facets ul li span.label").on("click", function() {
        $(this).toggleClass('label-success');
        $(this).toggleClass('label-default');
        taxonoverflow.updateFacetsFilter();
    });
};

taxonoverflow.updateFacetsFilter = function() {
    taxonoverflow.facetsFilter.tags = [];
    taxonoverflow.facetsFilter.types = [];
    $("#tagsFacet li span.label-success").each(function() {
        taxonoverflow.facetsFilter.tags.push($(this).text());
    });
    $("#typesFacet li span.label-success").each(function() {
        taxonoverflow.facetsFilter.types.push($(this).text());
    });
    taxonoverflow.doSearch();
};

taxonoverflow.doSearch = function() {
    window.location.href = taxonoverflow.searchUrl + "&f.tags=" + taxonoverflow.facetsFilter.tags.join(',') + "&f.types=" + taxonoverflow.facetsFilter.types.join(',');;
};