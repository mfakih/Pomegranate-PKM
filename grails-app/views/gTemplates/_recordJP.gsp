<g:set var="entityCode"
       value="${record.metaClass.respondsTo(record, 'entityCode') ? record.entityCode() : record.class?.name?.split(/\./).last()}"/>


<div class="recordDetailsBody" style="margin-left: 5px;" id="detailsRegion${entityCode}${record.id}">


<g:if test="${'TGRE'.contains(entityCode)}">
        <g:formRemote name="scheduleTask" url="[controller: 'task', action: 'assignRecordToDate']"
                      style="display: inline;" update="detailsRegion${entityCode}${record.id}"
                      method="post">
            <!-- Type/Level/Weight -->

            <g:select name="type" from="['J', 'P']" value="J"/>
            <g:select name="level" from="['e', 'y', 'M', 'W', 'd', 'm']" value="d"/>
            <g:select name="weight" from="${1..4}" value="1" title="weight"/>
            <input type="text" name="date" title="Format: wwd [hh]" placeholder="Date"
                   style="width: 70px;"
                   value="${mcs.Utils.toWeekDate(new Date())}"/>
            <input type="text" name="summary" title="" placeholder="Summary"
                   style="width: 180px;"
                   value=""/>


            <g:hiddenField name="recordType" value="${entityCode}"/>
            <g:hiddenField name="recordId" value="${record.id}"/>
            <g:submitButton name="scheduleTask" value="ok" style="display: none;"
                            class="fg-button ui-widget ui-state-default ui-corner-all"/>
        </g:formRemote>

    </g:if>

</div>