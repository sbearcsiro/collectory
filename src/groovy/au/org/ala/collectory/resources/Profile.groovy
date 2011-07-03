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

package au.org.ala.collectory.resources

import grails.converters.JSON

/**
 * User: markew
 * Date: 23/06/11
 */
enum Profile {
    NONE('none',[:]),
    DIGIR('DIGIR',
            ['url':'Service URL','resource':'Resource','termsForUniqueKey':'DwC terms that uniquely<br/> identify a record']),
    TAPIR('TAPIR',
            ['url':'Service URL','termsForUniqueKey':'DwC terms that uniquely<br/> identify a record']),
    BioCASe('BioCase',
            ['url':'Service URL','termsForUniqueKey':'DwC terms that uniquely<br/> identify a record']),
    CustomWebservice('Custom web service',
            ['url':'Service URL','params':'JSON map of parameters','termsForUniqueKey':'DwC terms that uniquely<br/> identify a record']),
    DwC('DarwinCore csv file',
            ['url':'Location URL','termsForUniqueKey':'DwC terms that uniquely<br/> identify a record']),
    DwCA('DarwinCore archive',
            ['url':'Location URL','termsForUniqueKey':'DwC terms that uniquely<br/> identify a record']),
    WebsiteWithSitemap('Website with sitemap',
            ['url':'Website URL','documentMapper':'Document mapper'])

    String name
    Map parameters = [:]

    Profile(String name, Map parameters) {
        this.name = name
        this.parameters = parameters
    }

    static List list() {
        Profile.values().collect {it.name}
    }

}
