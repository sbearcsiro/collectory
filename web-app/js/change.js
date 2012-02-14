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
 * Created by markew
 * Date: 26/11/11
 * Time: 4:52 PM
 */
var validator = {
        tips: null,

        updateTips: function (t) {
            var $tips = this.tips; // for use in the timeout function where this is a different context
            $tips
                .text(t)
                .addClass("ui-state-highlight");
                setTimeout(function() {
                    $tips.removeClass("ui-state-highlight", 1500);
                }, 500 );
        },

        checkLength: function (o, n, min, max) {
            if (o.val().length > max || o.val().length < min) {
                o.addClass("ui-state-error");
                this.updateTips("Length of " + n + " must be between " + min + " and " + max + ".");
                return false;
            } else {
                return true;
            }
        },
        checkRegexp: function (o, regexp, n) {
            if (!( regexp.test(o.val()))) {
                o.addClass("ui-state-error");
                this.updateTips(n);
                return false;
            } else {
                return true;
            }
        },
        checkUnique: function (o) {
            var isUnique = true;
            // make a synchronous call to check existence of the name
            $.ajax({
                url: "${ConfigurationHolder.config.grails.serverURL}/collection/nameExists?name=" + o.val(),
                dataType: 'json',
                async: false,
                success: function(data) {
                    if (data.found == 'true') {
                        o.addClass("ui-state-error");
                        this.updateTips("A collection with this name already exists (" + data.uid + ")");
                        isUnique = false;
                    }
                }
            });
            return isUnique;
        },
        checkDate: function (date, n) {
            //var regex = /\d\d\d\d(\-(0[1-9]|1[012])(\-((0[1-9])|1\d|2\d|3[01])(T(0\d|1\d|2[0-3])(:[0-5]\d){0,2})?)?)?|\-\-(0[1-9]|1[012])(\-(0[1-9]|1\d|2\d|3[01]))?|\-\-\-(0[1-9]|1\d|2\d|3[01])/;
            var regex = /^([\+-]?\d{4}(?!\d{2}\b))((-?)((0[1-9]|1[0-2])(\3([12]\d|0[1-9]|3[01]))?|W([0-4]\d|5[0-2])(-?[1-7])?|(00[1-9]|0[1-9]\d|[12]\d{2}|3([0-5]\d|6[1-6])))([T\s]((([01]\d|2[0-3])((:?)[0-5]\d)?|24\:?00)([\.,]\d+(?!:))?)?(\17[0-5]\d([\.,]\d+)?)?([zZ]|([\+-])([01]\d|2[0-3]):?([0-5]\d)?)?)?)?$/;
            return validator.checkRegexp(date, regex, n);
        }
    },

    transformer = {
        temporalSpan: function (start, end) {
            var text;
            if (start && end) {
                text = "The collection was established in " + start + " and ceased acquisitions in " + end + "."
            } else if (start) {
                text = "The collection was established in " + start + " and continues to the present."
            } else if (end) {
                text = "The collection ceased acquisitions in " + end + "."
            } else {
                text = "[No start or end date specified for this collection.]"
            }
            return text;
        },
        lsidHtml: function (lsid) {
            var authority = lsid.substring(9,lsid.indexOf(':',10));
            return '<a target="_blank" rel="nofollow" class="external" href="http://' + authority +
                    '/' + lsid +  '">' + lsid + '</a>';
        }
    },

    pageButtons = {
        changed: function (what) {
            var $save, $cancel, $buttons;
            // show save button if not already visible
            if ($('#pageButtons').length === 0) {
                $buttons = $('<span id="pageButtons"></span>').appendTo($('#breadcrumb'));
                $save = $('<button id="save">Save all changes</button>').appendTo($buttons);
                $cancel = $('<button id="cancel">Discard changes</button>').appendTo($buttons);
                $save.click(this.save);
                $cancel.click(this.cancel);
            }
            this.changes.push(what);
        },
        changes: [],
        save: function () {
            // save title
            var payload = {
                api_key: 'Venezuela',
                user: username
            };
            $.each(pageButtons.changes, function (i, name) {
                if (fields[name].pageStore != undefined) {
                    // use the page store for the value
                    payload[fields[name].property] =
                            $(fields[name].pageStore.selector).data(fields[name].pageStore.key);
                }
                else {
                    // just use the value being displayed
                    payload[fields[name].property] = $('#' + name).html();
                }
                // this moves all techDescription into the pubDescription
                if (name === "description") {
                    payload.techDescription = ""; // clear tech - all description written to pub
                }
            });
            $.ajax({
                type: 'POST',
                url: baseUrl + '/ws/collection/' + uid,
                data: JSON.stringify(payload),
                contentType: 'application/json',
                success: function(data, textStatus, jqXHR) {
                    //alert("Collection updated");
                    //window.location.href = baseUrl + "/manage/show/" + uid + "?message=Collection updated";
                    window,location.reload();
                },
                complete: function (jqXHR, textStatus) {
                    if (textStatus !== 'success') {
                        alert(textStatus + " (" + jqXHR.status + ") " + jqXHR.responseText);
                    }
                }
            });
        },
        cancel: function () {
            window,location.reload();
        }
    },

    fields = {
        name: {
            display: '#name',
            input: '#nameInput',
            property: "name",
            width: 500,
            title: 'Change the name of the collection',
            ok: function() {
                var field = this.id.substr(0, this.id.indexOf('-')),
                    bValid = true,
                    $input = $(fields[field].input),
                    $display = $(fields[field].display);

                $input.removeClass( "ui-state-error" );

                bValid = bValid && validator.checkLength( $input, "name", 3, 1024 );

                bValid = bValid && validator.checkRegexp( $input, /^[a-z]([0-9a-z_ ])+$/i,
                        "Name may consist of a-z, 0-9, underscores, begin with a letter." );

                //bValid = bValid && validator.checkUnique($nameInput);

                if ( bValid ) {
                    var val = $input.val();
                    if (val !== $display.html()) {
                        pageButtons.changed('name');
                        $display.html(val);
                    }
                    $(this).dialog("close");
                }
            }},
        acronym: {
            display: '#acronym',
            input: '#acronymInput',
            property: "acronym",
            width: 400,
            title: 'Change the acronym for the collection',
            ok: function() {
                var field = this.id.substr(0, this.id.indexOf('-')),
                    bValid = true,
                    $input = $(fields[field].input),
                    $display = $(fields[field].display);

                $input.removeClass( "ui-state-error" );

                bValid = bValid && validator.checkLength( $input, "acronym", 3, 45 );

                bValid = bValid && validator.checkRegexp( $input, /^[a-z]([0-9a-z_ ])+$/i,
                        "Acronym may consist of a-z, 0-9, underscores, begin with a letter.");

                if ( bValid ) {
                    var val = $input.val();
                    if (val !== $display.html()) {
                        pageButtons.changed('acronym');
                        $display.html(val);
                    }
                    $(this).dialog("close");
                }
            }
        },
        lsid: {
            display: '#lsid',
            input: '#lsidInput',
            property: "guid",
            pageStore: {selector: "#lsid", key: 'lsid'},
            width: 400,
            title: 'Enter a valid LSID for the collection if one exists',
            ok: function() {
                var field = this.id.substr(0, this.id.indexOf('-')),
                    bValid = true,
                    $input = $(fields[field].input),
                    $display = $(fields[field].display);

                $input.removeClass( "ui-state-error" );

                bValid = bValid && validator.checkLength( $input, "acronym", 0, 45 );

                bValid = bValid && validator.checkRegexp( $input, /urn:lsid:([\w\-\.]+\.[\w\-\.]+)+:\w+:\S+/i,
                        "A valid LSID has the form - URN:LSID:<Authority>:<Namespace>:<ObjectID>[:<Version>]");

                if ( bValid ) {
                    var val = $input.val();
                    if (val !== $display.html()) {
                        // store the data in the element
                        $display.data('lsid',val);
                        pageButtons.changed(field);
                        $display.html(transformer.lsidHtml(val));
                    }
                    $(this).dialog("close");
                }
            }
        },
        description: {
            display: "#description",
            input: "#descriptionInput",
            property: "pubDescription",
            width: 700,
            title: 'Edit the description of the collection',
            ok: function () {
                // update page
                var newContent = $('#descriptionInput').tinymce().getContent();
                $('#description').html(newContent);
                $(this).dialog("close");
                pageButtons.changed('description');
            }
        },
        temporalSpan: {
            display: "#temporalSpan",
            input: "#descriptionInput",
            property: "pubDescription",
            width: 400,
            title: 'Edit the start and end dates of the collection',
            ok: function () {
                var bValid = true,
                    sDate = $('#startDateInput'),
                    eDate = $('#endDateInput'),
                    sDateVal = sDate.val(),
                    eDateVal = eDate.val(),
                    $span = $('#temporalSpan');

                sDate.removeClass( "ui-state-error" );
                eDate.removeClass( "ui-state-error" );

                if (sDateVal !== "") {
                    bValid = validator.checkDate(sDate, "Bad start date");
                }
                if (eDateVal !== "") {
                    bValid = bValid && validator.checkDate(eDate, "Bad end date");
                }

                if (bValid) {
                    $span.html(transformer.temporalSpan(sDateVal, eDateVal));
                    // store actual data values in jquery data obj
                    $span.data('startDate', sDateVal);
                    $span.data('endDate', eDateVal);
                    $(this).dialog("close");
                    if (sDateVal != startDate) {
                        pageButtons.changed('startDate');
                    }
                    if (eDateVal != endDate) {
                        pageButtons.changed('endDate');
                    }
                }
            }
        },
        startDate: {
            property: 'startDate',
            pageStore: {selector: "#temporalSpan", key: 'startDate'}
        },
        endDate: {
            property: 'endDate',
            pageStore: {selector: "#temporalSpan", key: 'endDate'}
        },
        taxonomicRange: {
            title: "Edit the taxonomic range of the collection",
            property: ['focus','kingdomCoverage','scientificNames'],
            width: 700,
            ok: function () {

            }
        }
    },

    originalValues = {};

$(function() {
    validator.tips = $(".validateTips");
    var $nameInput = $("#nameInput"),
        $name = $('#name'),
        $acronymInput = $('#acronymInput'),
        $acronym = $('#acronym');

    for (var field in fields) {
        $('#' + field + '-dialog').dialog({
            autoOpen: false,
            width: fields[field].width,
            modal: true,
            title: fields[field].title,
            buttons: {
                "Ok": fields[field].ok,
                Cancel: function() {
                    $(this).dialog("close");
                }
            },
            close: function() {
                $('#' + field).removeClass( "ui-state-error" );
            }
        });
    }

    $('img.changeLink').click(function() {
        switch (this.id) {
            case 'nameLink':
                // make sure the dialog has the current value
                $nameInput.val($name.html());
                $("#name-dialog").dialog("open");
                break;
            case 'acronymLink':
                // make sure the dialog has the current value
                $acronymInput.val($acronym.html());
                $("#acronym-dialog").dialog("open");
                break;
            case 'lsidLink':
                // make sure the dialog has the current value
                $('#lsidInput').val($('#lsid a').html());
                $("#lsid-dialog").dialog("open");
                break;
            case 'descriptionLink':
                // see whether tinymce has already been initialised
                var inited = $('textarea.tinymce').attr('aria-hidden');
                if (inited === undefined) {
                    $('textarea.tinymce').tinymce({
                        script_url : baseUrl + '/js/tinymce/jscripts/tiny_mce/tiny_mce.js',
                        theme : "advanced",
                        width: "675",
                        height: "400",
                        plugins : "fullscreen",
                        theme_advanced_toolbar_location : "top",
                        theme_advanced_buttons1: "bold,italic,underline,bullist,numlist,undo,redo,link,unlink,cleanup,code,sub,sup,charmap,fullscreen,autoresize",
                        theme_advanced_buttons2: "",
                        theme_advanced_buttons3: ""
                    });
                    break;
                }
                // make sure the dialog has the current value
                $('#descriptionInput').html($('#description').html());
                // TODO: clear undo list else undo will reverse the above text insertion
                $("#description-dialog").dialog("open");
                break;
            case 'temporalSpanLink':
                var $span = $('#temporalSpan');

                // check whether dates have already been modified and stored in jquery data
                if ($span.data('startDate') != undefined) {
                    $('#startDateInput').val($('#temporalSpan').data('startDate'));
                    $('#endDateInput').val($('#temporalSpan').data('endDate'));
                }
                // otherwise use initial values
                else {
                    $('#startDateInput').val(startDate);
                    $('#endDateInput').val(endDate);
                }

                // show dialog
                $("#temporalSpan-dialog").dialog("open");
                break;
            case 'taxonomicRangeLink':
                // show dialog
                $("#taxonomicRange-dialog").dialog("open");
                break;
        }
    });
});