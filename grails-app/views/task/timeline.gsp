<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    %{--<meta name="layout" content="main"/>--}%
    <title>mcs timeline</title>
    <script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'jquery-1.3.2.min.js')}"></script>

    %{--<g:javascript library="prototype"/>--}%

    <script>
        Timeline_ajax_url = "${resource(dir:'/js/timeline_ajax', file:'simile-ajax-api.js')}"
        Timeline_urlPrefix = "${resource(dir:'/js/timeline_js')}/";
        Timeline_parameters = 'bundle=true';
    </script>
    <script src="${resource(dir: '/js/timeline_js', file: 'timeline-api.js')}"
            type="text/javascript">
    </script>

    <style type="text/css">

    #switch_theme {
        margin-left: 2em;
        cursor: pointer;
        background: #eee;
        padding: 4px 6px;
        width: 120px;
        text-align: center;
        font-weight: bold;
        border: 1px solid #999;
    }

    .t-highlight1 {
        background-color: #ccf;
    }

    .p-highlight1 {
        background-color: #fcc;
    }

    .timeline-highlight-label-start .label_t-highlight1 {
        color: #f00;
    }

    .timeline-highlight-label-end .label_t-highlight1 {
        color: #aaf;
    }

    .timeline-band-events .important {
        color: #f00;
    }

    .timeline-band-events .small-important {
        background: #c00;
    }

    </style>






    <script language="javascript" type="text/javascript">
        var tl;


        var resizeTimerID = null;
        function onResize() {
            if (resizeTimerID == null) {
                resizeTimerID = window.setTimeout(function () {
                    resizeTimerID = null;
                    tl.layout();
                }, 500);
            }
        }


        function themeSwitch() {
            var timeline = document.getElementById('tl');
            timeline.className = (timeline.className.indexOf('dark-theme') != -1) ? timeline.className.replace('dark-theme', '') : timeline.className += ' dark-theme';
        }

        jQuery(document).ready(function () {

            var eventSource = new Timeline.DefaultEventSource();

            var zones = [
                {
                    start:"Fri Nov 01 2011 00:00:00 GMT-0600",
                    end:"Mon Nov 30 2012 00:00:00 GMT-0600",
                    magnify:1,
                    unit:Timeline.DateTime.DAY
                }
            ];
            var zones2 = [
                {
                    start:"Fri Nov 01 2011 00:00:00 GMT-0600",
                    end:"Mon Nov 30 2012 00:00:00 GMT-0600",
                    magnify:1,
                    unit:Timeline.DateTime.WEEK
                }
            ];


            var theme = Timeline.ClassicTheme.create();
            //	Timeline.ThemeName = 'dark-theme'

            theme.event.bubble.width = 250;

            var date = "Fri Nov 01 2011 13:00:00 GMT-0600"
            var bandInfos = [
                Timeline.createHotZoneBandInfo({
                    width:"80%",
                    intervalUnit:Timeline.DateTime.DAY,
                    intervalPixels:50,
                    zones:zones,
                    eventSource:eventSource,
                    date:date,
                    timeZone:+2
                    //  theme:          theme
                }),
                Timeline.createHotZoneBandInfo({
                    width:"20%",
                    intervalUnit:Timeline.DateTime.WEEK,
                    intervalPixels:50,
                    zones:zones2,
                    eventSource:eventSource,
                    date:date,
                    timeZone:+2,
                    overview:true
                    // theme:          theme
                })
            ];
            bandInfos[1].syncWith = 0;
            bandInfos[1].highlight = true;

            for (var i = 0; i < bandInfos.length; i++) {
                bandInfos[i].decorators = [
                    /*    new Timeline.SpanHighlightDecorator({
                     startDate:  "Fri Nov 22 1963 12:30:00 GMT-0600",
                     endDate:    "Fri Nov 22 1963 13:00:00 GMT-0600",
                     color:      "#FFC080",
                     opacity:    50,
                     startLabel: "shot",
                     endLabel:   "t.o.d.",
                     // theme:      theme,
                     cssClass: 't-highlight1'
                     }),
                     */
                    new Timeline.PointHighlightDecorator({
                        date:"Fri Nov 01 2011 14:38:00 GMT-0600",
                        color:"#FFC080",
                        opacity:50,
                        //theme:      theme,
                        cssClass:'p-highlight1'
                    }),
                    new Timeline.PointHighlightDecorator({
                        date:"Sun Nov 30 2011 13:00:00 GMT-0600",
                        color:"#FFC080",
                        opacity:50
                        //theme:      theme
                    })
                ];
            }

            tl = Timeline.create(document.getElementById("tl"), bandInfos, Timeline.HORIZONTAL);
            tl.loadJSON("${createLink(controller: 'export', action:'getTimelineEvents')}", function (json, url) {
                eventSource.loadJSON(json, url);
            });
        });
    </script>
</head>

<body onresize="onResize();" style="margin:20px;">

%{--<g:render template="/task/toolbar" model="[breadCrumb: breadCrumb]"/>--}%

<div id="tl" class="timeline-default" style="height: 550px; width:950px; margin: 2em;z-index:500;">
</div>

<div class="body">

</div>

</body>
</html>
