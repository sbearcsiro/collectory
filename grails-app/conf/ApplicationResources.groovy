modules = {
    application {
        resource url:'js/application.js'
    }
    collectory {
        dependsOn 'bootstrap'
        resource url:'js/collectory.js'
        resource url:'css/temp-style.css'
    }
    charts {
        resource url:'js/charts.js'
    }
    jquery_jsonp {
        resource url:'js/jquery.jsonp-2.1.4.min.js'
    }
    jquery_tools {
        resource url: 'js/jquery.tools.min.js'
    }
    fancybox {
        resource url: 'js/jquery.fancybox/fancybox/jquery.fancybox-1.3.1.css'
        resource url: 'js/jquery.fancybox/fancybox/jquery.fancybox-1.3.1.pack.js'
    }
    jstree {
        resource url: 'js/jquery.jstree.js'
    }
    jquery_ui_custom {
       resource url: 'js/jquery-ui-1.8.16.custom.min.js'
    }
    datadumper {
       resource url: 'js/datadumper.js'
    }
    bbq {
        resource url: 'js/jquery.ba-bbq.min.js'
    }
    openlayers {
        resource url: 'http://openlayers.org/dev/OpenLayers.js'
        resource url: 'js/OpenLayers/theme/default/style.css'
    }
    map {
        resource url: 'js/map.js'
    }
    datasets {
        resource url:'js/datasets.js'
    }
    jquery_json {
        resource url:'js/jquery.json-2.2.min.js'
    }
    rotate {
        resource url:'js/jQueryRotateCompressed.2.1.js'
    }
    jquery {
        resource url:'js/jquery.min.js'
    }
    bigbuttons {
        resource url:'css/temp-style.css'
    }
}
