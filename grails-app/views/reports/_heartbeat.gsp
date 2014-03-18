<h2>Data entry over the days</h2>
<div id="graph${1}" style="width: 500px; height: 350px; margin: 3px auto 0 auto;"></div>

<script type="text/javascript">

    var day_data = [
        <%   dates.eachWithIndex(){ h, i -> if (i != dates.size() - 1) { %>
        {"date": "${h.key}", "Goal": ${h.value['Goal']?: 0},
            "Task": ${h.value['Task']?: 0},
            "Note": ${h.value['Note']?: 0},
            "Journal": ${h.value['Journal']?: 0},
            "Writing": ${h.value['Writing']?: 0}
            %{--"Resource": ${h.value['Resource']?: 0}--}%
        },
        <% } else { %>
        {"date": "${h.key}", "Goal": ${h.value['Goal']?: 0},
            "Task": ${h.value['Task']?: 0},
            "Note": ${h.value['Note']?: 0},
            "Journal": ${h.value['Journal']?: 0},
            "Writing": ${h.value['Writing']?: 0}
            %{--"Resource": ${h.value['Resource']?: 0}--}%
        }
        <% }}  %>
        //        {"period":"2012-09-10", "pln total":12, "pln completed":10}
    ];
    Morris.Line({
        element: 'graph${1}',
        data: day_data,
        xkey: 'date',
        ykeys: ['Goal','Task', 'Plan','Journal', 'Writing', 'Note'],
        ymin: 'auto',
//        hideHover: 'true',
        labels: ['Goal','Task', 'Plan','Journal', 'Writing', 'Note'],
        /* custom label formatting with `xLabelFormat` */
        xLabelFormat: function (d) {
           return d.getDate() + '.' + (d.getMonth() + 1) //+ '/' + d.getDate() + '/' + d.getFullYear();
        }
        ,
        /* setting `xLabels` is recommended when using xLabelFormat */
        xLabels: 'date'
    });

</script>


