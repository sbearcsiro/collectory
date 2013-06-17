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
        },
        checkNumber: function(o) {
            var input = o.val()
            if ((input - 0) == input) {
                return true;
            } else {
                o.addClass("ui-state-error");
                this.updateTips("Not a valid number");
                return false;
            }
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
        },
        checkboxesToList: function (checkedInputs) {
            var kc = [];
            $.each(checkedInputs, function(i, obj) {
                kc.push($(obj).val());
            });
            return kc;
        },
        commaSeparatedToList: function (str) {
            if (str === "") { return [] }
            var list = [];
            $.each(str.split(','), function (i,obj) {
                list.push(obj.trim());
            });
            return list;
        },
        listToString: function (list) {
            var len = list.length;
            //alert(list.join(' ') + " (" + len + ")");
            switch (len) {
                case 0: return "";
                case 1: return list[0];
                default: return list.slice(0,list.length - 1).join(', ') + " and " + list[list.length - 1];
            }
        },
        states: function (str) {
            if (str === "") { return ""; }
            if ($.inArray(str.toLowerCase(), ["all", "all states", "australian states"]) > -1) {
                return "All Australian states are covered.";
            } else {
                return "Australian states covered include: " + str + ".";
            }
        },
        numberWithCommas: function (str) {
            return str.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        }
    }

    pageButtons = {
        checkChanges: function () {
            var isChanged = false;
            for (var prop in values) {
                if (values[prop].changed) {
                    isChanged = true;
                    break;
                }
            }

            if (isChanged) {
                var $save, $cancel, $buttons;
                // show save button if not already visible
                if ($('#pageButtons').length == 0) {
                    $buttons = $('<span id="pageButtons"></span>').appendTo($('#breadcrumb'));
                    $save = $('<button id="save">Save all changes</button>').appendTo($buttons);
                    $cancel = $('<button id="cancel">Discard changes</button>').appendTo($buttons);
                    $save.click(this.save);
                    $cancel.click(this.cancel);
                } else {
                    $('span#pageButtons').show();
                }
            } else {
                if ($('#pageButtons').length > 0) {
                    $('span#pageButtons').hide();
                }
            }
        },
        changes: [],
        save: function () {
            // save title
            var payload = {
                api_key: 'Venezuela',
                user: username,
                uid: uid,
                version: version
            };
            for (var prop in values) {
                if (values[prop].changed) {
                    if (prop == 'contacts') {
                        payload[prop] = getContactUpdates();
                    } else {
                        payload[prop] = values[prop].current;
                    }
                }
            };
            $.ajax({
                type: 'POST',
                url: baseUrl + '/manage/update/',
                data: JSON.stringify(payload, function (key, value) {
                    if (value instanceof Array && value.length === 0) {
                        return "";
                    } else {
                        return value;
                    }
                }),
                contentType: 'application/json',
                success: function(data, textStatus, jqXHR) {
                    window.location.reload();
                },
                complete: function (jqXHR, textStatus) {
                    if (textStatus !== 'success') {
                        alert(textStatus + " (" + jqXHR.status + ") " + jqXHR.responseText);
                    }
                }
            });
        },
        cancel: function () {
            window.location.reload();
        }
    },

    dialogs = {
        name: {
            width: 500,
            title: 'Change the name of the collection',
            ok: function() {
                var bValid = true,
                    $input = $('#nameInput'),
                    $display = $('#name');

                $input.removeClass( "ui-state-error" );

                bValid = bValid && validator.checkLength( $input, "name", 3, 1024 );

                bValid = bValid && validator.checkRegexp( $input, /^[a-z]([0-9a-z_ ])+$/i,
                        "Name may consist of a-z, 0-9, underscores, begin with a letter." );

                //bValid = bValid && validator.checkUnique($nameInput);

                if ( bValid ) {
                    dialogs.checkAndUpdateText('name');
                    $(this).dialog("close");
                }
            }
        },
        acronym: {
            width: 400,
            title: 'Change the acronym for the collection',
            ok: function() {
                var bValid = true,
                    $input = $('#acronymInput');

                $input.removeClass( "ui-state-error" );

                bValid = bValid && validator.checkLength( $input, "acronym", 3, 45 );

                bValid = bValid && validator.checkRegexp( $input, /^[a-z]([0-9a-z_ ])+$/i,
                        "Acronym may consist of a-z, 0-9, underscores, begin with a letter.");

                if ( bValid ) {
                    dialogs.checkAndUpdateText('acronym');
                    $(this).dialog("close");
                }
            }
        },
        lsid: {
            pageStore: {selector: "#lsid", key: 'lsid'},
            width: 400,
            title: 'Enter a valid LSID for the collection if one exists',
            ok: function() {
                var bValid = true,
                    $input = $('#lsidInput'),
                    $display = $('#lsid');

                $input.removeClass( "ui-state-error" );

                bValid = bValid && validator.checkLength( $input, "lsid", 0, 45 );

                bValid = bValid && validator.checkRegexp( $input, /urn:lsid:([\w\-\.]+\.[\w\-\.]+)+:\w+:\S+/i,
                        "A valid LSID has the form - URN:LSID:<Authority>:<Namespace>:<ObjectID>[:<Version>]");

                if ( bValid ) {
                    dialogs.checkAndUpdateText('lsid');
                    $(this).dialog("close");
                }
            }
        },
        description: {
            width: 700,
            title: 'Edit the description of the collection',
            ok: function () {
                // update page
                var newContent = $('#descriptionInput').tinymce().getContent().replace(/\n/g, '');
                var description = $('#descriptionType').val();
                values[description].update(newContent);
                $('#' + description).html(newContent);
                pageButtons.checkChanges();
                $(this).dialog("close");
            }
        },
        temporalSpan: {
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
                    if (sDateVal != values.startDate.current || eDateVal != values.endDate.current) {
                        $span.html(transformer.temporalSpan(sDateVal, eDateVal));
                        values.startDate.update(sDateVal);
                        values.endDate.update(eDateVal);
                        pageButtons.checkChanges();
                    }
                }
                $(this).dialog("close");
            }
        },
        taxonomicRange: {
            title: "Edit the taxonomic range of the collection",
            width: 700,
            ok: function () {
                var $kingdomCoverageElement = $('#kingdomCoverage'),
                    $scientificNamesElement = $('#scientificNames'),
                    selectedKingdoms = transformer.checkboxesToList($('input:checked[name="kingdomCoverage"]')),
                    kingdomCoverageVal = selectedKingdoms.join(' '),
                    scientificNamesVal = transformer.commaSeparatedToList($('#scientificNamesInput').val());

                dialogs.checkAndUpdateText('focus');

                if (kingdomCoverageVal != values.kingdomCoverage.current) {
                    $kingdomCoverageElement.html("Kingdoms covered include: " + transformer.listToString(selectedKingdoms));
                    $kingdomCoverageElement.toggleClass('empty', kingdomCoverageVal === "");
                    values.kingdomCoverage.update(kingdomCoverageVal);
                    pageButtons.checkChanges();
                }

                if (scientificNamesVal.join(',') != values.scientificNames.current.join(',')) {
                    $scientificNamesElement.html(transformer.listToString(scientificNamesVal));
                    $('#sciNames').toggleClass('empty', scientificNamesVal.length === 0);
                    values.scientificNames.update(scientificNamesVal);
                    pageButtons.checkChanges();
                }

                $(this).dialog("close");
            }
        },
        geographicRange: {
            title: "Edit the geographic range of the collection",
            width: 700,
            ok: function () {
                dialogs.checkAndUpdateText("geographicDescription");
                dialogs.checkAndUpdateText("states", "states");
                $(this).dialog("close");
            }
        },
        records: {
            title: 'Edit the number of specimens in the collection',
            width: 400,
            ok: function() {
                var bValid = true,
                    $specimens = $('#numRecordsInput'),
                    $digitised = $('#numRecordsDigitisedInput');

                $specimens.removeClass( "ui-state-error" );
                $digitised.removeClass( "ui-state-error" );

                bValid = validator.checkNumber($specimens);
                bValid = bValid && validator.checkNumber($digitised);

                if ( bValid ) {
                    dialogs.checkAndUpdateText('numRecords', "numberWithCommas");
                    dialogs.checkAndUpdateText('numRecordsDigitised', "numberWithCommas");
                    $(this).dialog("close");
                }
            }
        },
        subCollections: {
            title: 'Edit the Sub-collections of the collection',
            width: 700,
            ok: function() {
                var subCollections = [];
                $('table#subCollections-table > tbody > tr').each(function() {
                    var name = $(this).find('textarea').first().val(),
                        description = $(this).find('textarea').last().val();
                    subCollections.push({name:name, description:description});
                });
                var jsonValue = JSON.stringify(subCollections);
                if (jsonValue !== values.subCollections.current) {
                    $('#subCollectionList > li').remove();
                    for (var i = 0; i < subCollections.length; i++) {
                        $("ul#subCollectionList").append("<li><span class='subName'>" + subCollections[i].name + "</span> - " + subCollections[i].description + "</li>");
                    }
                    values.subCollections.update(jsonValue);
                    pageButtons.checkChanges();
                }
                $(this).dialog("close");
            }
        },
        representativeImage: {
            title: 'Edit the representative image of the collection',
            width: 400,
            ok: function() {
                var bValid = true,
                    $imageFile = $('#imageFileInput'),
                    $imageCaption = $('#imageCaptionInput'),
                    $imageAttribution = $('#imageAttributionInput'),
                    $imageCopyright = $('#imageCopyrightInput');

                $imageFile.removeClass( "ui-state-error" );
                $imageCaption.removeClass( "ui-state-error" );
                $imageAttribution.removeClass( "ui-state-error" );
                $imageCopyright.removeClass( "ui-state-error" );

                bValid = true;

                if ( bValid ) {
                    // Capture dialog values
                    var cir = values.imageRef.current;
                    cir.file = noBlank($imageFile.val());
                    cir.caption = noBlank($imageCaption.val());
                    cir.attribution = noBlank($imageAttribution.val());
                    cir.copyright = noBlank($imageCopyright.val());

                    // Update imageRef fields on page
                    $('#representativeImage').empty();
                    if (cir.file == null) {
                        $('#representativeImage').append("<p class='caption'>No representative image</p>");
                    } else {
                        $('#representativeImage').append("<img style='max-width:100%;max-height:350px;' alt='" + cir.file + "' src='/Collectory/data/collection/" + cir.file + "'/>");
                        if (cir.caption != null) {
                            $('#representativeImage').append("<p class='caption'>" + cir.caption + "</p>");
                        }
                        if (cir.attribution != null) {
                            $('#representativeImage').append("<p class='caption'>" + cir.attribution + "</p>");
                        }
                        if (cir.copyright != null) {
                            $('#representativeImage').append("<p class='caption'>" + cir.copyright + "</p>");
                        }
                    }

                    values.imageRef.changed = !_.isEqual(values.imageRef.original, values.imageRef.current);
                    pageButtons.checkChanges();
                    $(this).dialog("close");
                }
            }
        },
        location: {
            width: 400,
            title: 'Edit the address for the collection',
            ok: function() {
                var bValid = true,
                    $street = $('#streetInput'),
                    $city = $('#cityInput'),
                    $state = $('#stateInput'),
                    $postcode = $('#postcodeInput'),
                    $country = $('#countryInput'),
                    $email = $('#emailInput'),
                    $phone = $('#phoneInput'),
                    $latitude = $('#latitudeInput'),
                    $longitude = $('#longitudeInput');

                $street.removeClass( "ui-state-error" );
                $city.removeClass( "ui-state-error" );
                $state.removeClass( "ui-state-error" );
                $postcode.removeClass( "ui-state-error" );
                $country.removeClass( "ui-state-error" );
                $email.removeClass( "ui-state-error" );
                $phone.removeClass( "ui-state-error" );
                $latitude.removeClass( "ui-state-error" );
                $longitude.removeClass( "ui-state-error" );

                bValid = true;

                if ( bValid ) {
                    // Capture dialog values
                    var ca = values.address.current;
                    ca.street = noBlank($street.val());
                    ca.city = noBlank($city.val());
                    ca.state = noBlank($state.val());
                    ca.postcode = noBlank($postcode.val());
                    ca.country = noBlank($country.val());

                    // Update address on page
                    $('#location').empty();
                    $('#location').append("<span id='street'>" + $street.val() + "</span><br/>");
                    $('#location').append("<span id='city'>" + $city.val() + "</span><br/>");
                    $('#location').append("<span id='state'>" + $state.val() + "</span> ");
                    $('#location').append("<span id='postcode'>" + $postcode.val() + "</span><br/>");
                    $('#location').append("<span id='country'>" + $country.val() + "</span><br/>");

                    values.address.changed = !_.isEqual(values.address.original, values.address.current);
                    dialogs.checkAndUpdateText('latitude');
                    dialogs.checkAndUpdateText('longitude');
                    //map.panTo(new google.maps.LatLng($latitude, $longitude));
                    pageButtons.checkChanges();
                    $(this).dialog("close");
                }
            },
            open: function() {
                var lat = $('#latitudeInput').val();
                if (lat == undefined || lat == 0 || lat == -1 ) {lat = -35.294325779329654}
                var lng = $('#longitudeInput').val();
                if (lng == undefined || lng == 0 || lng == -1 ) {lng = 149.10602960586547}
                var latLng = new google.maps.LatLng(lat, lng);
                editMap = new google.maps.Map(document.getElementById('editMapCanvas'), {
                    zoom: 16,
                    center: latLng,
                    mapTypeId: google.maps.MapTypeId.HYBRID,
                    streetViewControl: false
                });
                marker = new google.maps.Marker({
                    position: latLng,
                    title: 'my collection',
                    map: editMap,
                    draggable: true
                });

                // Add dragging event listeners.
                google.maps.event.addListener(marker, 'drag', function() {
                    updateMarkerPosition(marker.getPosition());
                });

                google.maps.event.addListener(marker, 'dragend', function() {
                    updateMarkerPosition(marker.getPosition());
                });
            }

        },
        contacts: {
            title: 'Edit contacts for the collection',
            width: 550,
            position: 'top',
            create: function() {
                // set all blank nullable fields to null to enable consistent change checking
                function nullBlankContactFields(contactFor) {
                    contactFor.contact.title = noBlank(contactFor.contact.title);
                    contactFor.contact.firstName = noBlank(contactFor.contact.firstName);
                    contactFor.contact.lastName = noBlank(contactFor.contact.lastName);
                    contactFor.contact.phone = noBlank(contactFor.contact.phone);
                    contactFor.contact.mobile = noBlank(contactFor.contact.mobile);
                    contactFor.contact.email = noBlank(contactFor.contact.email);
                    contactFor.contact.fax = noBlank(contactFor.contact.fax);
                    contactFor.contact.notes = noBlank(contactFor.contact.notes);
                    contactFor.role = noBlank(contactFor.role);
                }

                for (var i = 0; i < values.contacts.original.length; i++) {
                    nullBlankContactFields(values.contacts.original[i]);
                    // remove whitespace from name fields (input via textarea)
                    values.contacts.original[i].contact.firstName = $.trim(values.contacts.original[i].contact.firstName);
                    values.contacts.original[i].contact.lastName = $.trim(values.contacts.original[i].contact.lastName);
                }

                for (var i = 0; i < values.contacts.current.length; i++) {
                    nullBlankContactFields(values.contacts.current[i]);
                    // remove whitespace from name fields (input via textarea)
                    values.contacts.current[i].contact.firstName = $.trim(values.contacts.current[i].contact.firstName);
                    values.contacts.current[i].contact.lastName = $.trim(values.contacts.current[i].contact.lastName);
                }
            },
            open: function() {
                // initialise accordion content
                $("#accordion").accordion("destroy");
                $("#accordion").empty();
                for (var i = 0; i < values.contacts.current.length; i++) {
                    $("#accordion").append(contactPanelHtml(values.contacts.current[i]))
                }

                // initialise buttons
                $('.removeContact, .addExistingContact, .addNewContact').button();

                // render accordion
                $("#accordion").accordion({collapsible: true, active: false});
            },
            ok: function() {
                // update contact list for deletions and changes
                for (var i = 0; i < values.contacts.current.length; i++) {
                    var cf = values.contacts.current[i];
                    var id = cf.id;
                    var cfId = $("#contactForId" + id);
                    if (cfId.length == 0) {
                        values.contacts.current.splice(i, 1);
                    } else {
                        var contact = cfId.parents('.contact');
                        cf.contact.title = noBlank(contact.find('[id=title]').val());
                        cf.contact.firstName = noBlank(contact.find('[id=firstName]').val());
                        cf.contact.lastName = noBlank(contact.find('[id=lastName]').val());
                        cf.contact.phone = noBlank(contact.find('[id=phone]').val());
                        cf.contact.mobile = noBlank(contact.find('[id=mobile]').val());
                        cf.contact.email = noBlank(contact.find('[id=email]').val());
                        cf.contact.fax = noBlank(contact.find('[id=fax]').val());
                        cf.contact.notes = noBlank(contact.find('[id=notes]').val());
                        cf.contact.publish = contact.find('[id=publish]').is(':checked');
                        cf.role = noBlank(contact.find('[id=role]').val());
                        cf.administrator = contact.find('[id=administrator]').is(':checked');
                        cf.notify = contact.find('[id=notify]').is(':checked');
                        cf.primaryContact = contact.find('[id=primaryContact]').is(':checked');
                    }
                }

                // update contact list for insertions
                $('div#accordion div.contact').each(function(index) {
                    var id = $(this).find('input[name^="contactForId"]').val();
                    if (id.indexOf('new') != -1) {
                        var exists = false;
                        for (var i = 0; i < values.contacts.current.length; i++) {
                            if (values.contacts.current[i].id == id) {
                                exists = true;
                                break
                            }
                        }
                        if (!exists) {
                            // only insert a new contactFor instance once
                            var contactFor = new ContactFor();
                            contactFor.contact.title = noBlank($(this).find('[id=title]').val());
                            contactFor.contact.firstName = noBlank($(this).find('[id=firstName]').val());
                            contactFor.contact.lastName = noBlank($(this).find('[id=lastName]').val());
                            contactFor.contact.phone = noBlank($(this).find('[id=phone]').val());
                            contactFor.contact.mobile = noBlank($(this).find('[id=mobile]').val());
                            contactFor.contact.email = noBlank($(this).find('[id=email]').val());
                            contactFor.contact.fax = noBlank($(this).find('[id=fax]').val());
                            contactFor.contact.notes = noBlank($(this).find('[id=notes]').val());
                            contactFor.contact.publish = $(this).find('[id=publish]').is(':checked');
                            contactFor.contact.id = $(this).find('[id^=contactId]').val();
                            contactFor.role = noBlank($(this).find('[id=role]').val());
                            contactFor.administrator = $(this).find('[id=administrator]').is(':checked');
                            contactFor.notify = $(this).find('[id=notify]').is(':checked');
                            contactFor.primaryContact = $(this).find('[id=primaryContact]').is(':checked');
                            contactFor.id = id;
                            values.contacts.current.splice(values.contacts.current.length, 0, contactFor);
                        }
                    }
                });

                // update contacts on page
                $('div.contact').remove();
                for (var j = 0; j < values.contacts.current.length; j++) {
                    var contact = values.contacts.current[j].contact;
                    with (contact) {
                        $('div.contacts').append(
                            "<div class='contact'>" +
                                "<p class='contactName'>" + ((title == null) ? "" : title + " ") + firstName + " " + lastName + "</p>" +
                                "<p>" + noNull(values.contacts.current[j].role) + "</p>" +
                                (noNull(phone) != '' ? "<p>phone: " + phone + "</p>" : "") +
                                (noNull(fax) != '' ? "<p>fax: " + fax + "</p>" : "") +
                                "<p>" + (noNull(email) != '' ? "<span class='link' onclick='return sendEmail(" + ")'>email</span></p>" : "") +
                            "</div>");
                    }
                }

                values.contacts.changed = !_.isEqual(values.contacts.original, values.contacts.current);
                pageButtons.checkChanges();
                $(this).dialog("close");
            },
            addNew: function() {
                // Create a blank contact object
                var timestamp = event.timeStamp,
                    contactFor = new ContactFor();
                contactFor.id = 'new-' + timestamp;

                // add to end of list of contacts
                $('#accordion').append(contactPanelHtml(contactFor));

                // redraw the accordion
                var lastContact = $('div#accordion div.contact').length - 1;
                $('#accordion').accordion('destroy').accordion({collapsible: true, active: lastContact});

                // initialise the remove button
                $('div#accordion div.contact button.removeContact:last').button();
            },
            addExisting: function() {
                var contactId = $("#addContact").val();
                if (contactId != "null") {
                    $.getJSON(baseUrl + '/ws/contacts/' + contactId + '.json', function(data) {
                        var timestamp = event.timeStamp,
                            contactFor = new ContactFor();
                        contactFor.id = 'new-' + timestamp;

                        // populate contact data
                        $.each(data, function(key, val) {
                            contactFor.contact[key] = val;
                        });
                        contactFor.contact.id = contactId;

                        // add to end of list of contacts
                        $('#accordion').append(contactPanelHtml(contactFor));

                        // redraw the accordion
                        var lastContact = $('div#accordion div.contact').length - 1;
                        $('#accordion').accordion('destroy').accordion({collapsible: true, active: lastContact});

                        // initialise the remove button
                        $('div#accordion div.contact button.removeContact:last').button();
                    });
                }
            },
            remove: function() {
                var div = $(event.currentTarget).parents('div.contact');
                var h3 = div.prev();
                div.remove();
                h3.remove()
            }
        },
        websiteUrl: {
            width: 700,
            title: 'Edit the website URL for the collection/institution',
            ok: function() {
                var bValid = true,
                    $collectionWebsiteUrl = $('#collectionWebsiteUrlInput'),
                    $institutionWebsiteUrl = $('#institutionWebsiteUrlInput');

                $collectionWebsiteUrl.removeClass( "ui-state-error" );
                $institutionWebsiteUrl.removeClass( "ui-state-error" );

                bValid = true;

                if ( bValid ) {
                    dialogs.checkAndUpdateText('collectionWebsiteUrl');
                    dialogs.checkAndUpdateText('institutionWebsiteUrl');
                    $(this).dialog("close");
                }
            }
        },
        /** Handles ok processing for text properties.
         * @param f the name of the field
         * @param transform optional name of transformer method to use for display
         */
        checkAndUpdateText: function (f, transform) {
            var element = $('#' + f);
            var val = $('#' + f + 'Input').val();
            if (val != values[f].current) {
                if (transform !== undefined) {
                    element.html(transformer[transform](val)); // set transformed value on page
                } else {
                    element.html(val);  // set value on page
                }
                element.toggleClass('empty', val == "");  // toggle visibility of container in case there is extra text
                values[f].update(val);
                pageButtons.checkChanges();  // mark as changed
            }
        }
    },

    fields = {
        name: {
            display: '#name',
            property: "name"
        },
        acronym: {
            display: '#acronym',
            property: "acronym"
        },
        guid: {
            property: "guid",
            pageStore: {selector: "#lsid a", key: 'lsid'}
        },
        pubDescription: {
            display: "#description",
            property: "pubDescription"
        },
        techDescription: {
            display: "#description",
            property: "techDescription"
        },
        startDate: {
            property: 'startDate',
            pageStore: {selector: "#temporalSpan", key: 'startDate'}
        },
        endDate: {
            property: 'endDate',
            pageStore: {selector: "#temporalSpan", key: 'endDate'}
        },
        focus: {
            property: 'focus'
        },
        kingdomCoverage: {
            property: "kingdomCoverage"
        },
        scientificNames: {
            display: "scientificNames",
            property: 'scientificNames'
        }
    },

    values = {};

    function Value(value) {
        this.original = value;
        if (value instanceof Object) {
            this.current = deepCopy(value);
        } else {
            this.current = value;
        }
        this.changed = false;

        this.update = function(value) {
            this.current = value;
            this.changed = !_.isEqual(this.original, this.current);
        }
    }

    function Contact() {
        this.title = '';
        this.firstName = '';
        this.lastName = '';
        this.phone = '';
        this.mobile = '';
        this.email = '';
        this.fax = '';
        this.notes = '';
        this.publish = false;
        this.id = 'new-' + event.timeStamp;

//        this.equals = function(other) {
//            if (this === other) return true;
//            if (typeof this != typeof other) return false;
//            return (this.title == other.title &&
//                this.firstName == other.firstName &&
//                this.lastName == other.lastName &&
//                this.phone == other.phone &&
//                this.mobile == other.mobile &&
//                this.email == other.email &&
//                this.fax == other.fax &&
//                this.notes == other.notes &&
//                this.publish == other.publish &&
//                this.id == other.id);
//        }
    }

    function ContactFor() {
        this.role = '';
        this.administrator = false;
        this.notify = false;
        this.primaryContact = false;
        this.entityUid = '';
        this.contact = new Contact();
        this.id = null;

//        this.equals = function(other) {
//            if (this === other) return true;
//            if (typeof this != typeof other) return false;
//            return (this.role == other.role &&
//                this.administrator == other.administrator &&
//                this.notify == other.notify &&
//                this.primaryContact == other.primaryContact &&
//                this.entityUid == other.entityUid &&
//                this.contact.equals(other.contact) &&
//                this.id == other.id);
//        }
    }

    function deepCopy(obj) {
        if (Object.prototype.toString.call(obj) === '[object Array]') {
            var out = [], i = 0, len = obj.length;
            for ( ; i < len; i++ ) {
                out[i] = arguments.callee(obj[i]);
            }
            return out;
        }
        if (typeof obj === 'object') {
            if (obj == null) return null;
            var out = {}, i;
            for ( i in obj ) {
                out[i] = arguments.callee(obj[i]);
            }
            return out;
        }
        return obj;
    }

$(function() {
    var $showChangesLink = $('#showChangesLink');

    validator.tips = $(".validateTips");

    //var model = JSON.parse(modelJson);

    // toggle for recent changes
    $showChangesLink.click(function () {
        var $changes = $('#changes');
        if ($('#changes:visible').length > 0) {
            $changes.slideUp();
            $showChangesLink.html("Show recent changes");
        } else {
            $changes.slideDown();
            $showChangesLink.html("Hide recent changes");
        }
    });

    // bind click handler to twisty in recent changes
    $('p.relatedFollows').rotate({
        bind:
            {
                click: function() {
                    var $target = $(this).parent().find('table'),
                        $twisty = $(this).find('img');
                    if ($target.css('display') == 'none') {
                        $twisty.rotate({animateTo:90,duration:350});
                        $target.slideDown();
                    }
                    else {
                        $twisty.rotate({animateTo:0,duration:350});
                        $target.slideUp();
                    }
                    return false;
                }
            }
    });

    // init dialogs
    for (var dialog in dialogs) {
        $('#' + dialog + '-dialog').dialog({
            create: dialogs[dialog].create,
            autoOpen: false,
            width: dialogs[dialog].width,
            position: dialogs[dialog].position,
            modal: true,
            title: dialogs[dialog].title,
            buttons: {
                "Ok": dialogs[dialog].ok,
                Cancel: function() {
                    $(this).dialog("close");
                }
            },
            open: dialogs[dialog].open,
            close: function() {
                $('#' + dialog).removeClass( "ui-state-error" );
            }
        });
    }

    // handle change links - show dialogs
    $('img.changeLink').click(function() {
        switch (this.id) {
            case 'pubDescriptionLink':
            case 'techDescriptionLink':
                // see whether tinymce has already been initialised
                var inited = $('textarea.tinymce').attr('aria-hidden');
                if (inited === undefined) {
                    $('textarea.tinymce').tinymce({
                        script_url : baseUrl + '/js/tiny_mce/tiny_mce.js',
                        theme : "advanced",
                        width: "675",
                        height: "400",
                        plugins : "fullscreen",
                        theme_advanced_toolbar_location : "top",
                        theme_advanced_buttons1: "bold,italic,underline,bullist,numlist,undo,redo,link,unlink,cleanup,code,sub,sup,charmap,fullscreen,autoresize",
                        theme_advanced_buttons2: "",
                        theme_advanced_buttons3: ""
                    });
                }
                // note that this is loaded from the page elements not the currentValue object
                //  because we are leveraging the formattedText tag where the text is still in old markup
                var description = this.id.replace("Link", "");
                $('#descriptionType').val(description);
                $('#descriptionInput').html($('#' + description).html());
                // TODO: clear undo list else undo will reverse the above text insertion
                $("#description-dialog").dialog("open");
                break;
            default:
                // follows the convention: '<name>Link' opens '<name>-dialog'
                $('#' + this.id.substr(0, this.id.length - 4) + "-dialog").dialog("open");
        }
    });
});

function contactPanelHtml(contactFor) {
    var contact = contactFor.contact;
    var heading, html;
    with (contact) {
        heading = (firstName == '' && lastName == '') ? 'New Contact' : ((title == null) ? "" : title + " ") + firstName + " " + lastName;
        html =
            "<h3><a href='#'>" + heading + "</a></h3>" +
            "<div class='contact'>" +
                "<table>" +
                    "<tr><td><label for='title'>Title</label></td>" +
                    "<td><select name='title' id='title'>" + titleOptions(title) + "</select></td></tr>" +
                    "<tr><td><label for='firstName'>First Name</label></td>" +
                    "<td><input type='text' name='firstName' id='firstName' maxlength='60' size='40' value='" + noNull(firstName) +"'/></td></tr>" +
                    "<tr><td><label for='lastName'>Last Name</label></td>" +
                    "<td><input type='text' name='lastName' id='lastName' maxlength='60' size='40' value='" + noNull(lastName) +"'/></td></tr>" +
                    "<tr><td><label for='phone'>Phone</label></td>" +
                    "<td><input type='text' name='phone' id='phone' maxlength='60' size='40' value='" + noNull(phone) +"'/></td></tr>" +
                    "<tr><td><label for='mobile'>Mobile</label></td>" +
                    "<td><input type='text' name='mobile' id='mobile' maxlength='60' size='40' value='" + noNull(mobile) +"'/></td></tr>" +
                    "<tr><td><label for='email'>Email</label></td>" +
                    "<td><input type='text' name='email' id='email' maxlength='60' size='40' value='" + noNull(email) +"'/></td></tr>" +
                    "<tr><td><label for='fax'>Fax</label></td>" +
                    "<td><input type='text' name='fax' id='fax' maxlength='60' size='40' value='" + noNull(fax) +"'/></td></tr>" +
                    "<tr><td><label for='notes'>Notes</label></td>" +
                    "<td><textarea name='notes' cols='41' rows='3' id='notes'>" + noNull(notes) + "</textarea></td></tr>" +
                    "<tr><td><label for='publish'>Publish</label></td>" +
                    "<td><input type='checkbox' name='publish' id='publish'" + checked(publish) + "></td></tr>" +
                    "<tr><td><label for='role'>Role</label></td>" +
                    "<td><textarea name='role' cols='41' rows='2' id='role'>" + noNull(contactFor.role) + "</textarea></td></tr>" +
                    "<tr><td><label for='administrator'>Administrator</label></td>" +
                    "<td><input type='checkbox' name='administrator' id='administrator'" + checked(contactFor.administrator) + "></td></tr>" +
                    "<tr><td><label for='notify'>Notify</label></td>" +
                    "<td><input type='checkbox' name='notify' id='notify'" + checked(contactFor.notify) + "></td></tr>" +
                    "<tr><td><label for='primaryContact'>Primary contact</label></td>" +
                    "<td><input type='checkbox' name='primaryContact' id='primaryContact'" + checked(contactFor.primaryContact) + "></td></tr>" +
                "</table>" +
                "<button class='removeContact' onclick='dialogs.contacts.remove()'>Remove this contact</button>" +
                "<input type='hidden' name='contactId" + id + "' id='contactId" + id + "' value='" + id + "'/>" +
                "<input type='hidden' name='contactForId" + contactFor.id + "' id='contactForId" + contactFor.id + "' value='" + contactFor.id + "'/>" +
            "</div>";
    }

    return html;
}
function getContactUpdates() {
    var updates = [];

    function getContact(id, contacts) {
        var contact = null;
        for (var i = 0; i < contacts.length; i++) {
            if (contacts[i].id == id) {
                contact = contacts[i];
                break;
            }
        }
        return contact;
    }

    // handle deletions
    for (var i = 0; i < values.contacts.original.length; i++) {
        if (getContact(values.contacts.original[i].id, values.contacts.current) == null) {
            values.contacts.original[i].action = 'delete';
            updates.push(values.contacts.original[i]);
        }
    }

    // handle updates and insertions
    for (var i = 0; i < values.contacts.current.length; i++) {
        var original = getContact(values.contacts.current[i].id, values.contacts.original);
        if (original == null) {
            // new contactFor
            values.contacts.current[i].action = 'insert';
            updates.push(values.contacts.current[i]);
        } else {
            if (!_.isEqual(original, values.contacts.current[i])) {
                // changed
                values.contacts.current[i].action = 'update';
                updates.push(values.contacts.current[i]);
            }
        }
    }

    return updates;
}

function titleOptions(title) {
    var options = ['', 'Dr', 'Prof', 'Mr', 'Ms', 'Mrs', 'Assoc Prof', 'Assist Prof'];
    var html = '';
    for (var i = 0; i < options.length; i++) {
        if (options[i] == title) {
            html += "<option selected>" + options[i] + "</option>"
        } else {
            html += "<option>" + options[i] + "</option>"
        }
    }
    return html
}

function noNull(text) {
    if (text == null) {
        return ''
    } else {
        return text;
    }
}

function noBlank(text) {
    if (text == '') {
        return null;
    } else {
        return text;
    }
}

function checked(bool) {
    if (bool) {
        return " checked='checked'"
    } else {
        return ""
    }
}
