<%@ page import="mcs.Task" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <link rel="stylesheet" href="${createLinkTo(dir: 'css', file: 'fullcalendar.css')}"/>

    <script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'jquery-1.3.2.min.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'jquery.jqplot.min.js')}"></script>
    <script type="text/javascript"
            src="${resource(dir: 'js/jquery/plugins', file: 'jqplot.categoryAxisRenderer.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/jquery/plugins', file: 'jqplot.barRenderer.js')}"></script>
    <script type="text/javascript"
            src="${resource(dir: 'js/jquery/plugins', file: 'jqplot.dateAxisRenderer.min.js')}"></script>
    <script type="text/javascript"
            src="${resource(dir: 'js/jquery/plugins', file: 'jqplot.highlighter.min.js')}"></script>



    <title>EOWP <g:meta name="app.fullname"/></title>

    <script language="javascript" type="text/javascript">
        jQuery(document).ready(function () {

            jQuery.getJSON('/cmn/task/chart1Data', function (data) {

                        line1 = [
                            ['2008-06-30', 4],
                            ['2008-7-30', 6.5],
                            ['2008-8-30', 5.7],
                            ['2008-9-30', 9],
                            ['2008-10-30', 8.2]
                        ];
                        console.log('got: ' + data.data)
                        console.log('line is ' + line1)
                        plot1 = jQuery.jqplot('chart11', [data.data], {
                            title:'Customized Date Axis',
                            //    gridPadding:{right:35},

                            legend:{
                                show:true,
                                location:'nw'
                            },
                            highlighter:{
                                showTooltip:true,
                                tooltipFade:true
                            },

                            axes:{
                                xaxis:{
                                    renderer:jQuery.jqplot.DateAxisRenderer,
                                    tickOptions:{formatString:'%b%#d'},
                                    min:'Dec 1, 2009',
                                    tickInterval:'1 day'
                                }
                            },
                            series:[
                                {
                                    lineWidth:4,
                                    markerOptions:{style:'square'}
                                }
                            ]
                        });


                    }
            )


            line1 = [
                [4, 1]
            ];
            line2 = [
                [3, 1]
            ];
            line3 = [
                [7, 1]
            ];

            plot2 = jQuery.jqplot('chart2', [line1, line2, line3], {
                stackSeries:true,
                seriesDefaults:{
                    renderer:jQuery.jqplot.BarRenderer,
                    rendererOptions:{
                        barDirection:'horizontal',
                        barPadding:6,
                        barMargin:40
                    }
                },
                series:[
                    {
                        label:'1st Qtr'
                    },
                    {
                        label:'2nd Qtr'
                    }
                ],
                axes:{
                    yaxis:{
                        renderer:jQuery.jqplot.CategoryAxisRenderer, ticks:['Q1', 'Q2', 'Q3', 'Q4']
                    }, xaxis:{min:0, max:20, numberTicks:5}
                }
            });


        });
    </script>

</head>

<body>

<g:render template="/task/toolbar" model="[breadCrumb: breadCrumb]"/>

<div class="body">

    <div id="chart" style="margin-top:20px; margin-left:20px; width:400px; height:40px;"></div>

    <div id="chart11" style="margin-top:20px; margin-left:20px; width:900px; height:300px;"></div>

    <div id="chart2" style="margin-top:5px; margin-left:5px; width:320px; height:100px;"></div>

</div>

</body>
</html>
