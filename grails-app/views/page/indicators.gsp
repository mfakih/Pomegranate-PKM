%{--
  - Copyright (c) 2014. Mohamad F. Fakih (mail@mfakih.org)
  -
  - This program is free software: you can redistribute it and/or modify
  - it under the terms of the GNU General Public License as published by
  - the Free Software Foundation, either version 3 of the License, or
  - (at your option) any later version.
  -
  - This program is distributed in the hope that it will be useful,
  - but WITHOUT ANY WARRANTY; without even the implied warranty of
  - MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  - GNU General Public License for more details.
  -
  - You should have received a copy of the GNU General Public License
  - along with this program.  If not, see <http://www.gnu.org/licenses/>
  --}%

<%@ page import="app.IndicatorData; app.Indicator; mcs.Goal; mcs.Task; mcs.Journal; mcs.Writing; app.IndexCard; mcs.Excerpt; mcs.Book" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

    %{--<meta name="layout" content="main"/>--}%
    <title>&nbsp;Indicators</title>


    <link rel="shortcut icon" href="${resource(dir: 'images/icons', file: 'chart.ico')}" type="image/png"/>



    <r:require modules="application"/>
    <r:require module="fileuploader"/>
    <r:require modules="jquery"/>
    <r:require modules="jquery-ui"/>


    <r:layoutResources/>


    <link rel="stylesheet" href="${resource(dir: 'css', file: 'uploader.css')}"/>

    <link rel="stylesheet" href="${resource(dir: 'css', file: 'jquery-ui-1.8.22.custom.css')}"/>
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'jquery.autocomplete.css')}"/>


    %{--<uploader:head css="${resource(dir: 'css', file: 'uploader.css')}"/>--}%

    %{----}%

    %{--<uploader:head/>--}%


    <link rel="stylesheet" href="${resource(dir: 'css', file: 'jquery.continuousCalendar.css')}"/>



    %{--<script type="text/javascript" src="${resource(dir: 'js', file: 'jquery/jquery-1.3.2.min.js')}"></script>--}%



    <script type="text/javascript" src="${resource(dir: 'js', file: 'DateFormat.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'DateLocale.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'DateRange.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'DateTime.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.continuousCalendar-latest.js')}"></script>

    %{--<script type="text/javascript" src="${resource(dir: 'js', file: 'fileuploader.js')}"></script>--}%
    %{--<script type="text/javascript" src="${resource(dir: 'css', file: 'uploader.css')}"></script>--}%


    <script type="text/javascript" src="${resource(dir: 'js', file: 'raphael-min.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'morris.min.js')}"></script>


    <link rel="stylesheet" href="${resource(dir: 'css', file: 'fg.menu.css')}"/>

    <script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'ui.achtung-min.js')}"></script>
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'ui.achtung-min.css')}"/>

    <link rel="stylesheet" href="${resource(dir: 'css', file: 'morris.css')}"/>

    %{--<script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'fullcalendar.min.js')}"></script>--}%
    %{--<link rel="stylesheet" href="${resource(dir: 'css', file: 'fullcalendar.css')}"/>--}%

    <link rel="stylesheet" href="${resource(dir: 'css', file: 'main.css')}"/>


    <script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'fg.menu.js')}"></script>

    %{--<script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'jquery.jeditable.mini.js')}"></script>--}%
    <script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'jquery.blockUI.js')}"></script>



    <script type="text/javascript" src="${resource(dir: 'js', file: 'raphael-min.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'morris.js')}"></script>



    <script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'jquery.autocomplete.min.js')}"></script>

    %{--<script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'jquery.relatedselects.min.js')}"></script>--}%

    <script type="text/javascript" src="${resource(dir: 'js', file: 'mousetrap.min.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'mousetrap-global-bind.min.js')}"></script>




    <script type=text/javascript>

        jQuery(document).ready(function () {


        });

    </script>

</head>

<body style="margin:15px;">
<g:each in="${1..13}" var="c">
    <h1># ${c}</h1>
    <g:each in="${Indicator.findAllByBookmarkedAndCategory(true, c)}" var="r">

        <div style="float: left; border: 1px solid lightgrey; padding: 3px">
            <b style="padding-left: 15px;">${r.name}</b>

            <div id="ind${r.id}" style="width: 450px; height: 150px !important; margin: 3px auto 0 auto"></div>
        </div>


        <script type="text/javascript">

            var day_data${r.id} = [
                <% IndicatorData.findAllByIndicatorAndDepartmentIsNull(r).eachWithIndex(){ h, i -> if (i != IndicatorData.countByIndicatorAndDepartmentIsNull(r) - 1) { %>
                {"date": "${h.date.format('yyyy-MM-dd')}", "Value": ${h.value}},
                <% } else { %>
                {"date": "${h.date.format('yyyy-MM-dd')}", "Value": ${h.value}}
                <% }}  %>
                //        {"period":"2012-09-10", "pln total":12, "pln completed":10}
            ];
            Morris.Line({
                element: 'ind${r.id}',
                data: day_data${r.id},
                xkey: 'date',
                ykeys: ['Value'],
                labels: ['${r.name}'],
                goals: [${r.notes}],
                ymin: 'auto',
                smooth: false,
                lineColors: 'green',
                hideHover: 'true',
                hoverCallback: function (index, options, content) {
                    var row = options.data[index];
                    return index + ": " + content;
                }
//        ,
                /* custom label formatting with `xLabelFormat` */
//        xLabelFormat: function (d) {
//            return  d.getDate() + '.' + (d.getMonth() + 1) + '.' + d.getFullYear();
//        },
                /* setting `xLabels` is recommended when using xLabelFormat */
//        xLabels: 'day'
            });

        </script>

    </g:each>
    <div style="clear: both"/>
    <br/><hr style="color: gray"/><br/>
</g:each>

<div id="notificationArea"></div>

%{--<DIV class="ui-layout-south" style="">--}%
%{--<g:render template="/layouts/south"/>--}%
%{--</DIV>--}%

%{--<simpleModal:javascript />--}%

<r:layoutResources/>

</body>

%{--<r:layoutResources/>--}%

</html>
