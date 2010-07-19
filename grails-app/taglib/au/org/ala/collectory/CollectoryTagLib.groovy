package au.org.ala.collectory

import org.codehaus.groovy.grails.plugins.springsecurity.AuthorizeTools
import java.text.NumberFormat
import java.text.DecimalFormat
import org.codehaus.groovy.grails.web.util.StreamCharBuffer
import grails.converters.JSON
import org.codehaus.groovy.grails.commons.ConfigurationHolder

class CollectoryTagLib {

    def authenticateService

    static namespace = 'cl'

    /**
     * Decorates the role if present
     *
     * @attrs role the role to display
     */
    def roleIfPresent = { attrs, body ->
        out << (!attrs.role ? '' : ' - ' + attrs.role.encodeAsHTML())
    }

    /**
     * Indicates user can edit if admin
     *
     * @attrs admin is the user an admin for the collection
     */
    def adminIfPresent = { attrs, body ->
        out << (attrs.admin ? '(Authorised to edit this collection)' : '')
    }

    /**
     * Authorisation for editing is determined by roles and rights
     *
     * @attrs user to check
     * @attrs collection to check
     */
    def isAuth = { attrs, body ->
        boolean authorised = false
        if (AuthorizeTools.ifAllGranted('ROLE_ADMIN')) {
            authorised = true
        } else {
            Contact c = Contact.findByEmail(attrs.user)
            if (c) {
                ContactFor cf = ContactFor.findByContactAndEntityId(c, attrs.collection)
                authorised = cf?.administrator
            }
        }
        if (authorised) {
            out << body()
        } else {
            out << ' You are not authorised to change this collection '// + debugString
        }
    }

    def showDecimal = { attrs ->
        BigDecimal val = -1
        if (attrs.value?.class == BigDecimal.class) {
            val = attrs.value
        } else if (attrs.value?.class == StreamCharBuffer.class) {
            try {
                val = new BigDecimal(Double.parseDouble(attrs.value.toString()))
            } catch (NumberFormatException e) {}
        }
        if (val != -1) {
            NumberFormat formatter = new DecimalFormat("#0.000000")
            out << formatter.format(val)
            if (attrs.degree) {
                out << '&deg;'
            }
        }
    }

    /**
     * Show number and body if it is not -1 (indicated info not available)
     *
     * @attrs number
     */
    def numberIfKnown = {attrs, body ->
        out << (attrs.number == -1 ? "" : attrs.number + body())
    }

    def ifNotBlank = {attrs ->
        if (attrs.value) {
            out << "<p>"
            out << (attrs.prefix) ? attrs.prefix : ""
            out << attrs.value.encodeAsHTML()
            out << (attrs.postfix) ? attrs.postfix : ""

            // allow other content
            if (attrs.value2) {
                out << (attrs.join) ? attrs.join : ""
                out << (attrs.prefix) ? attrs.prefix : ""
                out << attrs.value2
                out << (attrs.postfix) ? attrs.postfix : ""

                if (attrs.value3) {
                    out << (attrs.join) ? attrs.join : ""
                    out << (attrs.prefix) ? attrs.prefix : ""
                    out << attrs.value3
                    out << (attrs.postfix) ? attrs.postfix : ""
                }
            }

            out << "</p>"
        }
    }

    def formatPercent = { attrs ->
        double percent
        try {
            percent = attrs.percent as double
        } catch (Exception e) {
            //out << e.message
            return
        }
        NumberFormat formatter
        if (percent == 0.0) {
            formatter = new DecimalFormat("#0")
        } else if (percent < 0.1) {
            formatter = new DecimalFormat("#0.00")
        } else if (percent > 50.0) {
            formatter = new DecimalFormat("#0")
        } else {
            formatter = new DecimalFormat("#0.0")
        }
        out << formatter.format(percent)
    }

    def percentIfKnown = { attrs ->
        double dividend
        double divisor
        try {
            dividend = attrs.dividend as double
            divisor = attrs.divisor as double
        } catch (Exception e) {
            //out << e.message
            return
        }
        //out << "dividend=" << dividend << " "
        //out << "divisor=" << divisor
        if (attrs.dividend == -1 || attrs.divisor == -1) {
            return
        }
        if (dividend && divisor) {
            double percent = dividend / divisor * 100
            NumberFormat formatter = new DecimalFormat("#0.0")
            out << formatter.format(percent) << ' %'
        }
    }

    def ifLSID = {attrs, body ->
        out << (body().startsWith('urn:lsid:') ? body() : "")
    }

    /**
     * Show lsid as a link
     *
     * @attrs guid
     * @attrs target
     */
    def guid = { attrs ->
        def lsid = attrs.guid
        def target = attrs.target
        if (target) {
            target = " target='" + target + "'"
        } else {
            target = ""
        }
        if (lsid =~ 'lsid') {  // contains
            out << "<a${target} class='external_icon' href='http://biocol.org/${lsid.encodeAsHTML()}'>${lsid.encodeAsHTML()}</a>"
        } else {
            out << lsid.encodeAsHTML()
        }
    }

    /**
     * This simplifies the coding for a property label that is looked up in the message properties and which may have
     * a tool tip as well.
     *
     * Implementation is a bit tricky because it calls other taglibs to expand tags.
     *
     * Usage is :
     *  <cl:label for="<property-name>" source="containing-class" default="<>default-value"/>
     * eg
     *  <cl:label for="eastCoordinate" source="infoSource" default="East Coordinate"/>
     *
     * Builds something like:
     *  <label for='eastCoordinate'>
     *    <span id='gui_0c5f0293aadeedb82edfc5d3370fcdf4' class='yui-tip'
     *      title='<span class="tooltip">Furthest point East for this dataset in decimal degrees</span>'>East Coordinate
     *    </span>
     *  </label>
     *
     * @attrs for the label
     * @attrs source the message code
     * @attrs default the default message
     */
    def label = {attrs ->
        def _for = attrs.for
        def source = attrs.source
        def _default = attrs.default

        def tooltipText = g.message(code: source + "." + _for + ".tooltip", default: "")
        def labelText = g.message(code: source + "." + _for + ".label", default: _default)

        out << "<label for='${_for}'>"

        if (tooltipText?.isEmpty()) {
            out << labelText
        } else {
            out << gui.toolTip(text: tooltipText, labelText)
        }
    
        out << "</label>"
    }
    
    /**
     * Generates submit buttons for web flows.
     *
     * Web flow events are not easily supported by submit buttons. The event can be the value of the button but this
     * tightly couples the controller to the view. This technique assumes there is a hidden field with id="event" and
     * name="_eventId". It builds a submit button with the form:
     *
     * <input type="submit" onclick="return document.getElementById('event').value = 'back'" value="${message(code: 'default.button.back.label', default: 'previous')}" />
     *
     * where the event is given by the value assigned to the hidden field.
     *
     * Tag is of the form: <cl:createFlowSubmit event="someEvent" value="labelToShow" />
     *
     * To create the button disabled or hidden (for layout purposes) use the attribute show=false
     *
     * @attrs event controls the event submitted AND the appearance of the button
     * @attrs show whether the button is enabled
     * @attrs value the text shown
     */
    def createFlowSubmit = {attrs ->
        def event = attrs.event
        if (!event) {
            out << '<!-- No event specified -->'
        }

        def tabIndex = ""
        if (event == 'next') {
            tabIndex = " tabIndex='1'"
        }
        out << """<input type="submit" class="${event}"${tabIndex} ${(attrs.show == 'false' ? "disabled='true' style='opacity:0.3;filter:alpha(opacity=30);' " : "")}onclick="return document.getElementById('event').value = '${event}'" value="${attrs.value}"/>"""
    }

    /**
     * Generates the set of nav buttons - back, next, cancel & done.
     *
     * - use attribute exclude to omit buttons, eg <cl:navButtons exclude="back" />
     * - excluded buttons are still created so they participate in layout
     *
     * @attrs exclude list of buttons to disable (eg back on the first page)
     * 
     */
    def navButtons = {attrs ->
        out << """<div class="buttons flowButtons">"""
        out << cl.createFlowSubmit(event:"back", show: attrs.exclude?.contains("back") ? "false" : "true",
                value:"${message(code: 'default.button.cancel.label', default: 'Previous')}")
        out << cl.createFlowSubmit(event:"cancel", show: attrs.exclude?.contains("cancel") ? "false" : "true",
                value:"${message(code: 'default.button.cancel.label', default: 'Cancel')}")
        out << cl.createFlowSubmit(event:"done", show: attrs.exclude?.contains("done") ? "false" : "true",
                value:"${message(code: 'default.button.done.label', default: 'Done')}")
        out << cl.createFlowSubmit(event:"next", show: attrs.exclude?.contains("next") ? "false" : "true",
                value:"${message(code: 'default.button.next.label', default: 'Next')}")
        out << "</div>"
    }

    //  Checkbox list that can be used as a more user-friendly alternative to
    // a multiselect list box
    def checkBoxList = {attrs, body ->
        def from = attrs.from
        def value = attrs.value
        def cname = attrs.name
        def isChecked, ht, wd, style, html

        //  sets the style to override height and/or width if either of them
        //  is specified, else the default from the CSS is taken
        style = "style='"
        if(attrs.height)
            style += "height:${attrs.height};"
        if(attrs.width)
            style += "width:${attrs.width};"

        if (style.length() == "style='".length())
            style = ""
        else
            style += "'" // closing single quote

        html = "<ul class='CheckBoxList' " + style + ">"

        out << html

        from.each { obj ->

            //println "checkBoxList> ${obj}"
            // if we wanted to select the checkbox using a click anywhere on the label (also hover effect)
            // but grails does not recognize index suffix in the name as an array:
            //      cname = "${attrs.name}[${idx++}]"
            //      and put this inside the li: <label for='$cname'>...</label>

            if (attrs.optionKey) {
                isChecked = (value?.contains(obj."${attrs.optionKey}"))? true: false
                out << "<li>" <<
                    checkBox(name:cname, value:obj."${attrs.optionKey}", checked: isChecked) <<
                        "${obj}" << "</li>"
            } else {
                isChecked = (value?.contains(obj))? true: false
                out << "<li>" <<
                    checkBox(name:cname, value:obj, checked: isChecked) <<
                        "${obj}" << "</li>"
            }

        }

        out << "</ul>"

    }

    /**
     * Converts a ProviderGroup groupType to a controller name
     */
    def controller = {attrs ->
        if (attrs.type == ProviderGroup.GROUP_TYPE_INSTITUTION) {
            out << 'institution'
        } else {
            out << 'collection'
        }
    }

    /**
     * Inserts a help button in a <td> element which will toggle the visibility of a help div in the previous <td> element.
     */
    def helpTD = {
        out << '<td><img class="helpButton" alt="help" src="' + resource(dir:'images/skin', file:'help.gif') + '" onclick="toggleHelp(this);"/></td>'
    }

    /**
     * Inserts a help button which will toggle the visibility of a help div in the previous <td> element.
     */
    def help = { attrs ->
        if (attrs.javascript) {
            out << "<img style='float:right;margin-right:20px;' class='helpButton' alt='help' src='" +
                    resource(dir:"images/skin", file:"help.gif") +
                    "' onclick='${attrs.javascript}'/>"
        } else {
            out << '<img style="float:right;margin-right:20px;" class="helpButton" alt="help" src="' +
                    resource(dir:'images/skin', file:'help.gif') +
                    '" onclick="toggleHelp(this);"/>'
        }
    }

    /**
     * Displays a JSON list as a comma-separated list of strings
     */
    def JSONListAsStrings = {attrs ->
        if (!attrs?.json)
            return ""
        def list = JSON.parse(attrs.json.toString())
        String str = ""
        list.each {(str == "") ? (str += it) : (str += ", " + it)}
        out << str.encodeAsHTML()
    }

    /**
     * Displays a JSON list as an unordered list of strings
     */
    def JSONListAsList = {attrs ->
        if (!attrs?.json)
            return ""
        def list = JSON.parse(attrs.json.toString())
        String str = "<ul>"
        list.each {str += "<li>${it.encodeAsHTML()}</li>"}
        str += "</ul>"
        out << str
    }

    /**
     * Displays label, count and percent of total as 3 table columns
     * @param total - divisor in percent calculation
     * @param with - count to display, dividend in percent calc
     * @param without - 'inverse' of count to display, ie display total - this number
     */
    def totalAndPercent = {attrs ->
        def count = 0
        if (attrs.with) {
            count = attrs.with
        } else {
            count = attrs.total - attrs.without
        }
        out << """<td>${attrs.label}</td><td>${count}</td>\n
         <td>${cl.percentIfKnown(dividend:count, divisor:attrs.total)}</td>"""
    }

    /**
     * Inserts a hidden div holding the specified help text.
     */
    def helpText = { attrs ->
        def _default = attrs.default ? attrs.default : ""
        def id = attrs.id ? "id='${attrs.id}' " : ""
        out << '<div ' + id + 'class="fieldHelp" style="display:none">' + message(code:attrs.code, default: _default) + '</div>'
    }

    /**
     * Selects the words to describe the start and end dates of a collection based on data availability.
     */
    def temporalSpan = { attrs ->
        if (attrs.start && attrs.end)
          out << "<p>The collection was established in ${attrs.start} and ceased acquisitions in ${attrs.end}.</p>"
        else if (attrs.start)
          out << "<p>The collection was established in ${attrs.start} and continues to the present.</p>"
        else if (attrs.end)
          out << "<p>The collection ceased acquisitions in ${attrs.end}.</p>"
    }

    def stateCoverage = {attrs ->
        if (!attrs.states) return
        if (attrs.states.toLowerCase() in ["all", "all states", "australian states"]) {
            out << "All Australian states are covered."
        } else {
            out << "Australian states covered include " + attrs.states.encodeAsHTML()
        }
    }

    /**
     * A little bit of email scrambling for dumb scrappers.
     *
     * Uses email attribute as email if present else uses the body.
     *
     * @attrs email the address to decorate
     * @body the text to use as the link text
     */
    def emailLink = { attrs, body ->
        def strEncodedAtSign = "(SPAM_MAIL@ALA.ORG.AU)"
        String email = attrs.email
        if (!email)
            email = body().toString()
        int index = email.indexOf('@')
        //println "index=${index}"
        if (index > 0) {
            email = email.replaceAll("@", strEncodedAtSign)
        }
        out << "<a href='#' onclick=\"return sendEmail('${email}')\">${body()}</a>"
    }

    def emailBugLink = { attrs, body ->
        def strEncodedAtSign = "(SPAM_MAIL@ALA.ORG.AU)"
        String email = attrs.email
        if (!email)
            email = body().toString()
        int index = email.indexOf('@')
        //println "index=${index}"
        if (index > 0) {
            email = email.replaceAll("@", strEncodedAtSign)
        }
        out << "<a href='#' onclick=\"return sendBugEmail('${email}','${attrs.message}')\">${body()}</a>"
    }

    def collectionName = { attrs ->
        if (!attrs.name || attrs.name =~ 'Collection') {
            out << attrs.name
        } else {
            out << attrs.name + " Collection"
        }
    }

    def subCollectionDisplay = { attrs ->
        if (attrs.sub?.description) {
            out << "<span class='subName'>" + attrs.sub?.name + "</span>" + " - " + attrs.sub?.description
        } else {
            out << "<span class='subName'>" + attrs.sub?.name + "</span>"
        }
    }

    def subCollectionList = { attrs ->
        out << """<tr><td valign="top" class="name">${message(code:"collection.subcollections.label", default:"Sub-collections")}</td><td valign="top" class="value">"""
        if (attrs.list) {
            out << "<ul>"
            JSON.parse(attrs.list).each { sub ->
                //log.info "sub: " + sub
                out << "<li>${cl.subCollectionDisplay(sub: sub)}</li>"
            }
            out << "</ul>"
        }
        out << "</td></tr>"
    }

    /**
     * Takes the values as java list or JSON string and sets up checkboxes.
     */
    def checkboxSelect = {attrs ->
        out << "<table class='shy CheckBoxList CheckBoxArray'><tr>"
        //log.info "attrs.value=${attrs.value}"
        attrs.from.eachWithIndex { it, index ->
            def checked
            if (attrs.value instanceof String) {
                checked = (attrs.value.indexOf(it) >= 0) ? "checked='checked'" : ""
            } else {
                checked = (it in attrs.value) ? "checked='checked'" : ""
            }
            out << "<td><input name='${attrs.name}' type='checkbox' ${checked}' value='${it}'/>${it}</td>"
            if (index > 0 && ((index+1) % 6) == 0) {
                out << "</tr>"
            }
        }
        out << "</tr></table>"
    }

    /**
     * Formats free text so line feeds are honoured and urls are linked.
     *
     * @param attrs.noLink suppresses links
     * @param body the text to format
     */
    def formattedText = {attrs, body ->
        def text = body().toString()
        if (text) {
            text = text.replaceAll("\n", "</p><p>")
            if (!attrs.noLink) {
                def urlMatch = /\bhttp:\S*\b/   // word boundary + http: + non-whitespace + word boundary
                text = text.replaceAll(urlMatch) {
                    "<a class='external_icon' target='_blank' href='${it}'>${it}</a>"
                }
            }
            out << "<p>${text}</p>"
        }
    }

    /**
     * Builds the link to bio-cache records for the passed collection.
     *
     * @param collection the collectio to search for
     * @body the body of the link
     */
    def recordsLink = {attrs, body ->
        // must have at least one value to build a query
        if (attrs.collection) {
            def baseUrl = ConfigurationHolder.config.biocache.baseURL
            def url = baseUrl + "searchForCollection?q=" + attrs.collection?.generatePermalink()
            out << "<a href='"
            out << url
            out << "'>" << body() << "</a>"
        }
    }

    def numberOf = {attrs->
        if (attrs.number) {
            NumberFormat formatter = new DecimalFormat(",###")
            out << formatter.format(attrs.number)
        } else {
            out << "no"
        }
        out << " "
        out << (attrs.number == 1 ? attrs.noun : attrs.noun + "s")
    }

    def permalink = {attrs, body ->
        def context
        switch (attrs.type) {
            case 'institution': context = '/public/showInstitution/'; break
            case 'collection': context = '/public/show/'; break
            default: context = '/public/show/'; break
        }
        if (context) {
            def url = ConfigurationHolder.config.grails.serverURL + context + attrs.id
            out << "<a href='${url}'>"
            out << ((body() != "") ? body() : context + attrs.id)
            out << "</a>"
        }
    }

}
