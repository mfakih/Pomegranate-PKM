<%@ page import="mcs.Writing; mcs.Book; org.apache.commons.lang.StringUtils; ker.OperationController; app.parameters.Blog; org.ocpsoft.prettytime.PrettyTime; cmn.Setting; ys.wikiparser.WikiParser; mcs.Journal; app.Payment; app.IndicatorData; app.IndexCard; mcs.Excerpt; mcs.Planner; java.text.DecimalFormat" %>
<g:set var="entityCode"
       value="${record.metaClass.respondsTo(record, 'entityCode') ? record.entityCode() : record.class?.name?.split(/\./).last()}"/>


<div class="recordDetailsBody" style="margin-left: 5px;" id="detailsRegion${entityCode}${record.id}">


<g:if test="${entityCode == 'L'}">

    <g:render template="/gTemplates/recordListing"
              model="[list: Payment.findAllByCategory(record, [sort: 'date', order: 'desc'])]"/>

</g:if>

<g:elseif test="${entityCode == 'K'}">

    <div id="graph${record.id}" style="width: 500px; height: 200px; margin: 3px auto 0 auto;"></div>

    <script type="text/javascript">

        var day_data = [
            <% IndicatorData.findAllByIndicator(record).eachWithIndex(){ h, i -> if (i != IndicatorData.countByIndicator(record) - 1) { %>
            {"date": "${h.date.format('yyyy-MM-dd')}", "Value": ${h.value}},
            <% } else { %>
            {"date": "${h.date.format('yyyy-MM-dd')}", "Value": ${h.value}}
            <% }}  %>
            //        {"period":"2012-09-10", "pln total":12, "pln completed":10}
        ];
        Morris.Line({
            element: 'graph${record.id}',
            data: day_data,
            xkey: 'date',
            ykeys: ['Value'],
            ymin: 'auto',
            hideHover: 'true',
            labels: ['Value'],
            /* custom label formatting with `xLabelFormat` */
            xLabelFormat: function (d) {
                return  d.getDate() + '.' + (d.getMonth() + 1) //+ '/' + d.getDate() + '/' + d.getFullYear();
            },
            /* setting `xLabels` is recommended when using xLabelFormat */
            xLabels: 'day'
        });

    </script>


    <g:render template="/gTemplates/recordListing"
              model="[list: IndicatorData.findAllByIndicator(record, [sort: 'date', order: 'desc'])]"/>

</g:elseif>

<g:elseif test="${entityCode == 'P'}">

    <g:if test="${record.completedOn}">
        Completed on: ${record.completedOn?.format('dd.MM.yyyy')}
    </g:if>
    <g:if test="${record.task}">
        <g:render template="/gTemplates/recordSummary" model="[record: record.task]"/>
    </g:if>
    <g:if test="${record.goal}">
        <g:render template="/gTemplates/recordSummary" model="[record: record.goal]"/>
    </g:if>
</g:elseif>

<g:elseif test="${entityCode == 'T'}">
    <g:render template="/gTemplates/recordListing" model="[list: Planner.findAllByTask(record)]"/>
    <g:render template="/gTemplates/recordListing" model="[list: Journal.findAllByTask(record)]"/>
</g:elseif>
<g:elseif test="${entityCode == 'C'}">
    <g:render template="/gTemplates/recordListing" model="[list: Planner.findAllByCourse(record)]"/>
    <g:render template="/gTemplates/recordListing" model="[list: Journal.findAllByCourse(record)]"/>
</g:elseif>

<g:elseif test="${entityCode == 'R'}">

    <g:render template="/gTemplates/recordListing" model="[list: Excerpt.findAllByBook(record)]"/>
    <g:render template="/gTemplates/recordListing" model="[list: Planner.findAllByBook(record)]"/>
    <g:render template="/gTemplates/recordListing" model="[list: Journal.findAllByBook(record)]"/>

</g:elseif>

<g:elseif test="${entityCode == 'E'}">
    <g:render template="/gTemplates/recordListing" model="[list: Planner.findAllByExcerpt(record)]"/>
    <g:render template="/gTemplates/recordListing" model="[list: Journal.findAllByExcerpt(record)]"/>

</g:elseif>

<g:elseif test="${entityCode == 'G'}">
%{--<h4>J & P</h4>--}%
    <g:render template="/gTemplates/recordListing" model="[list: Planner.findAllByGoal(record)]"/>
    <g:render template="/gTemplates/recordListing" model="[list: Journal.findAllByGoal(record)]"/>

</g:elseif>





<br/>