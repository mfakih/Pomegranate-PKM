
<div id="graph${1}" style="width: 500px; height: 350px; margin: 3px auto 0 auto;"></div>

<script type="text/javascript">

    var day_data = [
        <%   dates.eachWithIndex(){ h, i -> if (i != dates.size() - 1) { %>
        {"date": "${h.key}", "New tasks": ${h.value['newTasks']?: 0},
            "Completed tasks": ${h.value['completedTasks']?: 0}
        },
        <% } else { %>
        {"date": "${h.key}", "New tasks": ${h.value['newTasks']?: 0},
            "Completed tasks": ${h.value['completedTasks']?: 0}
        }
        <% }}  %>
        //        {"period":"2012-09-10", "pln total":12, "pln completed":10}
    ];
    Morris.Line({
        element: 'graph${1}',
        data: day_data,
        xkey: 'date',
        ykeys: ['newTasks', 'completedTasks'],
        ymin: 'auto',
//        hideHover: 'true',
        labels: ['New tasks','Completed tasks'],
        /* custom label formatting with `xLabelFormat` */
        xLabelFormat: function (d) {
           return d.getDate() + '.' + (d.getMonth() + 1) //+ '/' + d.getDate() + '/' + d.getFullYear();
        }
        ,
        /* setting `xLabels` is recommended when using xLabelFormat */
        xLabels: 'date'
    });

</script>


