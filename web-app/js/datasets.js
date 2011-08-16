/*
 * Copyright (C) 2011 Atlas of Living Australia
 * All Rights Reserved.
 *
 * The contents of this file are subject to the Mozilla Public
 * License Version 1.1 (the "License"); you may not use this file
 * except in compliance with the License. You may obtain a copy of
 * the License at http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS
 * IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
 * implied. See the License for the specific language governing
 * rights and limitations under the License.
 */
/**
 * User: markew
 * Date: 15/08/11
 * Time: 8:47 AM
 */

/* holds full list of resources */
var allResources;

/* holds current filtered list */
var resources;

/* list of filters currently in effect - items are {facet, value} */
var currentFilters = [];

/* pagination offset into the record set */
var offset = 0;

/* size of current filtered list */
var total = 0;

/* the base url of the home server */
var baseUrl;

/** load resources and show first page **/
function loadResources(serverUrl) {
    baseUrl = serverUrl;
    $.getJSON(baseUrl + "/public/resources.json", function(data) {
        allResources = data;
        // no filtering at this stage
        resources = allResources;

        setStateFromHash();
        updateTotal();
        calculateFacets();
        showFilters();
        resources.sort(comparator);
        displayPage();
        wireDownloadLink();
    });
}
/*************************************************\
 *  List display
 \*************************************************/
/** display a page **/
function displayPage() {
    // clear list
    $('#results div').remove();

    // paginate and show list
    for (var i = 0; i < pageSize(); i++) {
        var item = resources[offset + i];
        // item will be undefined if there are less items than the page size
        if (item != undefined) {
            appendResource(item);
        }
    }
    activateClicks();
    showPaginator();
}
/** append one resource to the list **/
function appendResource(value) {
    var $div = $('<div class="result"></div>');
    $('#results').append($div);
    $div.append('<p class="rowA">Data set: <span class="result-name">' + value.name + '</span></p>');
    $div.append('<p class="rowB"><span><strong class="resultsLabel">Type of resource: </strong>' + value.resourceType + '</span>' +
            '<span><strong class="resultsLabel">License: </strong>' + (value.licenseType == null ? '' : value.licenseType) + '</span>' +
            '<span><strong class="resultsLabel">License version: </strong>' + (value.licenseVersion == null ? '' : value.licenseVersion) + '</span>' +
            '<span><a href="' + baseUrl + '/public/showDataResource/' + value.uid + '">View metadata</a></span>' +
            (value.resourceType == 'records' ?
                    '<span><a href="http://biocache-test.ala.org.au/occurrences/search?q=data_resource_uid:' + value.uid +
                            '">View records</a></span>' : '') +
            (value.resourceType == 'website' && value.websiteUrl ?
                    '<span><a class="external" target="_blank" href="' + value.websiteUrl + '">Website</a></span>' : '') + '</p>');
    var desc = "";
    if (value.pubDescription != null && value.pubDescription != "" && value.pubDescription != "null") {
        desc += value.pubDescription;
    }
    if (value.techDescription != null && value.techDescription != "") {
        desc += value.techDescription;
    }
    if (desc == "") {
        desc = "No further information available.";
    }
    $div.append('<div class="rowC" style="display:none;">' + desc + '</div>');
}
/** bind click handler to titles **/
function activateClicks() {
    $('.result-name').click(function() {
        var $target = $(this).parent().parent().find('.rowC');
        $target.slideToggle(350);
        return false;
    });
}
/** clear the list and reset values **/
function clearList() {
    resources = [];
    total = 0;
    offset = 0;
    $.bbq.removeState('offset');
}
/** display the current size of the filtered list **/
function updateTotal() {
    total = resources.length;
    $('#resultsReturned strong').html(total);
    $('#downloadLink').attr('title', 'Download metadata for ' + total + ' datasets as a CSV file');
}
/*************************************************\
 *  Filters
 \************************************************/
/** applies current filters to the list **/
function filterList() {
    clearList();
    // revert to full list
    resources = allResources;
    // apply each filter in effect
    $.each(currentFilters, function(index, value) {
        filterBy(value.facet, value.value);
    });
    updateTotal();
    calculateFacets();
    showFilters();
    displayPage();
}
/** applies a single filter to the list **/
function filterBy(facet, facetValue) {
    var newResourcesList = [];
    $.each(resources, function(index, value) {
        if (value[facet] == facetValue || (facetValue == 'noValue' && value[facet] == null)) {
            newResourcesList.push(value);
        }
    });
    resources = newResourcesList;
}
/** displays the current filters **/
function showFilters() {
    $('#currentFilter').remove();
    if (currentFilters.length > 0) {
        // create the container
        $('#currentFilterHolder').append('<div id="currentFilter"><h4><span class="FieldName">Current Filters</span></h4>' +
                '<div id="subnavlist"><ul></ul></div></div>');
    }
    $.each(currentFilters, function(index, obj) {
        $('#currentFilter #subnavlist ul').append('<li>' + labelFor(obj.facet) + ': <b>' + labelFor(obj.value) + '</b>&nbsp;' +
                '[<b><a href="#" onclick="removeFilter(\'' + obj.facet + "','" + obj.value + '\');return false;"' +
                'class="removeLink" title="remove">X</a></b>]</li>');
    });
}
/** adds a filter and re-filters list**/
function addFilter(facet, value) {
    currentFilters.push({facet:facet, value:value});
    serialiseFiltersToHash();
    filterList();
}
/** removes a filter and re-filters list**/
function removeFilter(facet, value) {
    var idx = -1;
    $.each(currentFilters, function(index, obj) {
        if (obj.facet == facet && obj.value == value) {
            idx = index;
        }
    });
    if (idx > -1) {
        currentFilters.splice(idx, 1);
    }
    serialiseFiltersToHash();
    filterList();
}
/*************************************************\
 *  Pagination
 \*************************************************/
/** build and append the pagination widget **/
function showPaginator() {
    if (total <= pageSize()) {
        // no pagination required
        $('div#navLinks').html("");
        return;
    }
    var currentPage = Math.floor(offset / pageSize()) + 1;
    var maxPage = Math.ceil(total / pageSize());
    var $pago = $("<ul></ul>");
    // add prev
    if (offset > 0) {
        $pago.append('<li id="prevPage"><a href="javascript:prevPage();">« Previous</a></li>');
    }
    else {
        $pago.append('<li id="prevPage">« Previous</li>');
    }
    for (var i = 1; i < 10 && i <= maxPage; i++) {
        if (i == currentPage) {
            $pago.append('<li class="currentPage">' + i + '</li>');
        }
        else {
            $pago.append('<li><a href="javascript:gotoPage(' + i + ');">' + i + '</a></li>');
        }
    }
    // add next
    if ((offset + pageSize()) < total) {
        $pago.append('<li id="nextPage"><a href="javascript:nextPage();">Next »</a></li>');
    }
    else {
        $pago.append('<li id="nextPage">Next »</li>');
    }

    $('div#navLinks').html($pago);
}
/** get current page size **/
function pageSize() {
    return parseInt($('select#per-page').val());
}
/** show the specified page **/
function gotoPage(pageNum) {
    // calculate new offset
    offset = (pageNum - 1) * pageSize();
    displayPage();
}
/** show the previous page **/
function prevPage() {
    // calculate new offset
    offset = offset - pageSize();
    displayPage();
}
/** show the next page **/
function nextPage() {
    // calculate new offset
    offset = offset + pageSize();
    $.bbq.pushState({offset:offset});
    displayPage();
}
/** action for changes to the pageSize widget */
function onPageSizeChange() {
    offset = 0;
    $.bbq.pushState({pageSize:pageSize()});
    displayPage();
}
/** action for changes to the sort widget */
function onSortChange() {
    offset = 0;
    $.bbq.pushState({sort:$('select#sort').val()});
    resources.sort(comparator);
    displayPage();
}
/** action for changes to the sort order widget */
function onDirChange() {
    offset = 0;
    $.bbq.pushState({dir:$('select#dir').val()});
    resources.sort(comparator);
    displayPage();
}
/* comparator for data resources */
function comparator(a, b) {
    var va, vb;
    var sortBy = $('select#sort').val();
    switch ($('select#sort').val()) {
        case 'name':
            va = a.name;
            vb = b.name;
            break;
        case 'type':
            va = a.resourceType;
            vb = b.resourceType;
            break;
        case 'license':
            va = a.licenseType;
            vb = b.licenseType;
            break;
        default:
            va = a.name;
            vb = b.name;
    }
    if (va == vb) {
        // sort on name
        va = a.name;
        vb = b.name;
    }
    // use lowercase
    va = va == null ? "" : va.toLowerCase();
    vb = vb == null ? "" : vb.toLowerCase();

    if ($('select#dir').val() == 'asc') {
        return (va < vb ? -1 : (va > vb ? 1 : 0));
    }
    else {
        return (vb < va ? -1 : (vb > va ? 1 : 0));
    }
}

/*************************************************\
 *  Facet management
 \*************************************************/

/* this holds the display text for all values of facets - keyed by the facet value */
// the default if not in this list is to capitalise the record value
// also holds display text for the facet categories
var displayText = {
    resourceType:"Resource type",licenseType:"License type",licenseVersion:"License version",status:"Integration status",
    ccby:"CC BY", ccbync:"CC BY-NC", ccbysa:"CC BY-SA", ccbyncsa:"CC BY-NC-SA", other:"Custom license",
    noLicense:"No license information", noValue:"No information", '3.0':"CC 3.0", '2.5':"CC 2.5",
    dataAvailable:"Data available",linksAvailable:"Links available",inProgress:"In progress"
};

var helpText = {
    records:"Contributes occurrence records to the Atlas",website:"Describes a website resource",
    document:"Contributes the contents of a document",uploads:"The data has been uploaded directly to the Atlas",
    'CC BY':"Creative Commons Attribution", 'CC BY-NC':"Creative Commons Attribution-NonCommercial",
    'CC BY-SA':"Creative Commons Attribution-ShareAlike", 'CC BY-NC-SA':"Creative Commons Attribution-NonCommercial-ShareAlike",
    other:"Uses a custom rights statement",noLicense:"No license information is available", noValue:"No information is available",
    '3.0':"Creative Commons version 3.0", '2.5':"Creative Commons version 2.5",
    dataAvailable:"Data is directly accessible in the Atlas",linksAvailable:"Provides links to content on other sites",
    inProgress:"Negotiation for integration into the Atlas is in progress",declined:"The resource has declined to contribute to the Atlas",
    identified:"Has been identifed but not yet approached for contribution to the Atlas"
};

/* List of dataset attributes to treat as facets */
var facets = ["resourceType", "licenseType", "licenseVersion", "status"];

/** Returns a map of distinct values of the facet and the number of each for the current filtered list **/
function getSetOfFacetValuesAndCounts(facet) {
    var map = {};
    $.each(resources, function(index, value) {
        var attr = value[facet];
        if (!attr) {
            attr = "noValue"
        }
        if (map[attr] == undefined) {
            map[attr] = 1;
        }
        else {
            map[attr]++;
        }
    });
    return map;
}

/** Creates DOM elements to represent the facet **/
function displayFacet(facet, list) {
    var $div = $("<div></div>");
    $div.append('<h4><span class="FieldName">' + labelFor(facet) + '</span></h4>');
    var $list = $('<ul class="facets"></ul>').appendTo($div);
    $.each(list, function(index, value) {
//        if (index == 0) { alert(value.facetValue + ":" + value.count) }
        var attr = value.facetValue;
        var count = value.count;
        var help = helpText[attr] == undefined ? '' : 'title="' + helpText[attr] + '"';

        $list.append('<li><a href="javascript:addFilter(\'' + facet + "','" + attr + '\')" ' + help + '>' +
                labelFor(attr) + '</a> (<span>' + count + '</span>)</li>');
    });
    return $div;
}

/** calculate facet totals and display them **/
function calculateFacets() {
    $('div#facets div').remove();
    $.each(facets, function(index, value) {
//        var list = getSetOfFacetValuesAndCounts(value);
        var list = sortByCount(getSetOfFacetValuesAndCounts(value));
//        alert(list[0].facetValue + ":" + list[0].count);
        // don't show if only one value
        if (list.length > 1) {
            $('div#facets').append(displayFacet(value, list));
        }
    });
}

/* sorts a map in desc order based on the map values */
function sortByCount(map) {
    // turn it into an array of maps
    var list = [];
    for (var item in map) {
        list.push({facetValue:item, count:map[item]});
    }
    list.sort(function(a, b) {
        return b.count - a.count
    });
    return list;
}

/* returns a display label for the facet */
function labelFor(item) {
    var text = displayText[item];
    if (text == undefined) {
        // just capitalise - TODO: break out camel case
        text = capitalise(item);
    }
    return text;
}
/* capitalises the first letter of the passed string */
function capitalise(item) {
    if (!item) {
        return item;
    }
    if (item.length == 1) {
        return item.toUpperCase();
    }
    return item.substring(0, 1).toUpperCase() + item.substring(1, item.length);
}

/*************************************************\
 *  Download csv of data sets
 \*************************************************/
function wireDownloadLink() {
    $('#downloadLink').click(function() {
        var filters = $.toJSON(currentFilters);
        document.location.href = baseUrl + "/public/downloadDataSets?filters=" + filters;
        return false;
    });
}

/*************************************************\
 *  State handling
 \*************************************************/
/* called on page load to set the initial state */
function setStateFromHash() {
    var hash = $.deparam.fragment(true);
    if (hash.pageSize) {
         $('select#per-page').val(hash.pageSize);
    }
    if (hash.sort) {
        $('select#sort').val(hash.sort);
    }
    if (hash.dir) {
        $('select#dir').val(hash.dir);
    }
    if (hash.filters) {
        deserialiseFilters(hash.filters);
    }
    if (hash.offset && hash.offset < total) {
        offset = hash.offset;
    }
}
/* puts the current filter state into the hash */
function serialiseFiltersToHash() {
    var str = "";
    $.each(currentFilters, function(i, obj) {
        str += obj.facet + ":" + obj.value + ";";
    });
    if (str.length == 0) {
        $.bbq.removeState('filters');
    }
    else {
        str = str .substr(0,str.length - 1);
        $.bbq.pushState({filters:str});
    }
}
/* reinstates current filters from the specified hash */
function deserialiseFilters(filters) {
    var list = filters.split(";");
    $.each(list, function(i, obj) {
        var bits = obj.split(':');
        addFilter(bits[0], bits[1]);
    });
}
/* sets the controls for the heart of the sun */
function reset() {
    currentFilters = [];
    resources = allResources;
    offset = 0;
    $('select#per-page').val(20);
    $('select#sort').val('name');
    $('select#dir').val('asc');
    $.bbq.removeState();
    updateTotal();
    calculateFacets();
    showFilters();
    displayPage();
}