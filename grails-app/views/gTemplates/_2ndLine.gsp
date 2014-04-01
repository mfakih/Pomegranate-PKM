<%@ page import="mcs.Writing; mcs.Book; cmn.Setting; org.apache.commons.lang.StringEscapeUtils; app.Payment; app.IndicatorData; app.IndexCard; mcs.Excerpt; java.text.DecimalFormat; mcs.parameters.WorkStatus; mcs.Goal; mcs.parameters.JournalType; mcs.Journal; mcs.Planner; mcs.Task" %>


<div class="recordContainer"
     style="background: #f2f2f2;  box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.2); padding: 3px;  margin-top: 0px; border-radius: 2px; margin-bottom: 15px;">

<table class="fixed-layout recordLine">
<tr class="secondLine">


%{--<pkm:simpleModal--}%
%{--link="${createLink(controller: 'task', action: 'qedit', params: [id: record.id])}"--}%
%{--title="Editing goal $record.id : ${fieldValue(bean: record, field: 'name')}"--}%
%{--body="edit">--}%
%{--</eowp:simpleModal>--}%



%{--<g:remoteLink controller="${entityCode}" action="details" id="${record.id}"--}%
%{--update="below${entityCode}Record${record.id}"--}%
%{--class=" fg-button fg-button-icon-solo ui-widget ui-state-default ui-corner-all"--}%
%{--title="Details">--}%
%{--<span class="ui-icon ui-icon-info"></span>--}%
%{--</g:remoteLink>--}%




<td  style="width: 90%">
%{--<span style="border: 1px solid #5c5c5c; border-radius: 5px">--}%

<g:if test="${record.class.declaredFields.name.contains('course') && record.course}">
    <span title="${record.course?.summary}">
        <g:remoteLink controller="generics" action="quickEdit" id="${record.id}"
                      params="[entityCode: entityCode, field: 'course',
                              valueId: (record.course ? record.course?.id : 0), updateDiv: 'quickEditCourse' + record.id]"
                      update="quickEditCourse${record.id}"
                      title="Edit course">
            C</g:remoteLink><sup><span id="quickEditCourse${record.id}"
                                       style="font-weight: bold; color: #1f3d5f">${record.course ? record.course?.code : '...'}</span>
    </sup></span>
</g:if>
<g:if test="${record.class.declaredFields.name.contains('department')}">
    <span title="${record.department}">
        <g:remoteLink controller="generics" action="quickEdit" id="${record.id}"
                      params="[entityCode: entityCode, field: 'department',
                              valueId: (record.department ? record.department?.id : 0), updateDiv: 'quickEditDepartment' + record.id]"
                      update="quickEditDepartment${record.id}"
                      title="Edit department">
            Dept. <span id="quickEditDepartment${record.id}">
            ${record.department ? record.department?.code : '...'}
        </span>
        </g:remoteLink>

    </span>
</g:if>




<g:if test="${'E'.contains(entityCode)}">
    <b style="font-family: Courier">${record.book?.course?.code}</b>
</g:if>

<g:if test="${entityCode == 'Q'}">
    ${record?.category?.code}
</g:if>

%{--</span>--}%

%{--<td class="record-summary ${'TGP'.contains(entityCode) ? 'workStatus' + record.status.id : ''} ${'WI'.contains(entityCode) ? 'writingStatus' + record.status.id : ''}" style="font-family: Arial; font-size: 14px; color: #105CB6; line-height: 16px; ">--}%

<g:if test="${'WN'.contains(entityCode)}">
    <g:remoteLink controller="generics" action="quickEdit" id="${record.id}"
                  params="[entityCode: entityCode, field: 'writingType',
                          valueId: (record.type ? record.type?.id : 0), updateDiv: 'quickEditType' + record.id]"
                  update="quickEditType${record.id}"
                  title="Edit type">
        <span id="quickEditType${record.id}">
            ${record.type?.code ?: 'No type'}
        </span>
    </g:remoteLink>

</g:if>
<g:if test="${'G'.contains(entityCode)}">
    <g:remoteLink controller="generics" action="quickEdit" id="${record.id}"
                  params="[entityCode: entityCode, field: 'goalType',
                          valueId: (record.type ? record.type?.id : 0), updateDiv: 'quickEditType' + record.id]"
                  update="quickEditType${record.id}"
                  title="Edit type">
        <span id="quickEditType${record.id}">
            ${record.type?.code ?: 'No type'}
        </span>
    </g:remoteLink>

</g:if>
<g:if test="${'J'.contains(entityCode)}">
    <g:remoteLink controller="generics" action="quickEdit" id="${record.id}"
                  params="[entityCode: entityCode, field: 'journalType',
                          valueId: (record.type ? record.type.id : 0), updateDiv: 'quickEditType' + record.id]"
                  update="quickEditType${record.id}"
                  title="Edit type">
        <span id="quickEditType${record.id}">
            ${record.type?.code ?: 'No type'}
        </span>
    </g:remoteLink>
</g:if>
<g:if test="${'P'.contains(entityCode)}">

    <g:remoteLink controller="generics" action="quickEdit" id="${record.id}"
                  params="[entityCode: entityCode, field: 'plannerType',
                          valueId: (record.type ? record.type.id : 0), updateDiv: 'quickEditType' + record.id]"
                  update="quickEditType${record.id}"
                  title="Edit status">
        <span id="quickEditType${record.id}">
            ${record.type?.code ?: 'No type'}
        </span>
    </g:remoteLink>

</g:if>

<g:if test="${entityCode == 'T'}">
    <g:remoteLink controller="generics" action="quickEdit" id="${record.id}"
                  params="[entityCode: entityCode, field: 'location',
                          valueId: (record.location ? record?.location?.id : 0), updateDiv: 'quickEditLocation' + record.id]"
                  update="quickEditLocation${record.id}"
                  title="Edit location">
        <span id="quickEditLocation${record.id}">
            ${record?.location?.code ?: 'No location'}
        </span>
    </g:remoteLink>
    &nbsp;
    &nbsp;
    <g:remoteLink controller="generics" action="quickEdit" id="${record.id}"
                  params="[entityCode: entityCode, field: 'plannedDuration',
                          valueId: (record.plannedDuration ? record.plannedDuration : 0), updateDiv: 'quickEditPlannedDuration' + record.id]"
                  update="quickEditPlannedDuration${record.id}"
                  title="Edit plannedDuration">
        <span id="quickEditPlannedDuration${record.id}">
            ${record.plannedDuration ? record.plannedDuration + '"' : '"No duration'}
        </span>
    </g:remoteLink>

    &nbsp;
    &nbsp;
    ${record.orderInCourse ? '#' + record.orderInCourse : ''}

</g:if>

<g:if test="${entityCode == 'I'}">
    ${record.indicator?.code}
</g:if>

<g:if test="${entityCode == 'Q'}">

</g:if>


%{--<g:if test="${entityCode == 'R' && record.resourceType == 'ebk'}">--}%
%{----}%
%{--<a href="${createLink(controller: 'book', action: 'download', id: record.id)}"--}%
%{--target="_blank">--}%

%{--<img class="Photo" style="width: 50; height: 65; display:inline"--}%
%{--src="${createLink(controller: 'book', action: 'viewImage', id: record.id, params: [date: new Date()])}"/>--}%
%{--</a>--}%
%{--</g:if>--}%

<g:if test="${entityCode == 'I'}">
    %{--${record.category}--}%
</g:if>


<g:if test="${entityCode == 'Q'}">
    ${record.amount}
</g:if>
<g:if test="${entityCode == 'I'}">
    <g:formatNumber number="${record.value}" format="#,###"/>
</g:if>

%{--</td>--}%
%{--<td class="record-status">--}%


<g:if test="${'GT'.contains(entityCode)}">
    <g:remoteLink controller="generics" action="quickEdit" id="${record.id}"
                  params="[entityCode: entityCode, field: 'workStatus',
                          valueId: (record.status ? record.status.id : 0), updateDiv: 'quickEditStatus' + record.id]"
                  update="quickEditStatus${record.id}"
                  title="Edit status">
        <span id="quickEditStatus${record.id}">
            ${record.status?.code ?: 'No status'}
        </span>
    </g:remoteLink>
</g:if>
<g:if test="${'W'.contains(entityCode)}">
    <g:remoteLink controller="generics" action="quickEdit" id="${record.id}"
                  params="[entityCode: entityCode, field: 'writingStatus',
                          valueId: (record.status ? record.status.id : 0), updateDiv: 'quickEditStatus' + record.id]"
                  update="quickEditStatus${record.id}"
                  title="Edit status">
        <span id="quickEditStatus${record.id}">

            ${record.status?.code ?: 'No status'}
        </span>
    </g:remoteLink>
</g:if>
<g:if test="${'R'.contains(entityCode)}">
    <g:remoteLink controller="generics" action="quickEdit" id="${record.id}"
                  params="[entityCode: entityCode, field: 'resourceStatus',
                          valueId: (record.status ? record.status.id : 0), updateDiv: 'quickEditStatus' + record.id]"
                  update="quickEditStatus${record.id}"
                  title="Edit status">
        <span id="quickEditStatus${record.id}">
            ${record.status?.code ?: 'No status'}
        </span>
    </g:remoteLink>
</g:if>


<g:if test="${'P'.contains(entityCode)}">
    <g:remoteLink controller="generics" action="quickEdit" id="${record.id}"
                  params="[entityCode: entityCode, field: 'workStatus',
                          valueId: (record.status ? record.status.id : 0), updateDiv: 'quickEditStatus' + record.id]"
                  update="quickEditStatus${record.id}"
                  title="Edit status">
        <span id="quickEditStatus${record.id}">
            <g:if test="${record.status?.code != 'completed' && record.startDate < new Date() - 1}">
                <b style="color: red">${record.status?.code ?: '?...'}</b>
            </g:if>
            <g:else>
                ${record.status?.code ?: 'No status'}
            </g:else>
        </span>
    </g:remoteLink>
</g:if>




<g:if test="${entityCode == 'N'}">
    <g:if test="${record.recordId}">

        <g:remoteLink controller="generics" action="showSummary" id="${record.recordId}"
                      params="[entityCode: record.entityCode]"
                      update="below${entityCode}Record${record.id}"
                      title="Go to parent record">
            <span class="ui-icon-arrow-2-e-w"></span>
        </g:remoteLink>

    </g:if>
</g:if>




<g:if test="${'JWN'.contains(entityCode)}">
    %{--<g:remoteLink controller="generics" action="quickEdit" id="${record.id}"--}%
                  %{--params="[entityCode: entityCode, field: 'blog',--}%
                          %{--valueId: (record.blog?.id ?: null), updateDiv: 'quickEditBlog' + record.id]"--}%
                  %{--update="quickEditBlog${record.id}"--}%
                  %{--title="ID ${record.publishedNodeId ?: '?'} ${record.publishedOn ? ' on ' + record.publishedOn?.format('dd.MM.yyyy HH:mm') : ''}">--}%
        %{--<span id="quickEditBlog${record.id}"><span>${record.blog?.code ? record.blog?.code : 'No blog'}</span> </span>--}%
    %{--</g:remoteLink>--}%

    <a href="#" id="blog"  class="blog" data-type="select" data-value="${record.blog?.id}" data-name="blog-${record.entityCode()}"
       data-source="operation/getQuickEditValues?entity=${record.entityCode()}&field=blog"
       data-pk="${record.id}" data-url="operation/quickSave2" data-title="Edit blog">
       ${record.blog?.code ?: 'No blog'}
    </a>
    <script>
        $('.blog').editable();
    </script>

</g:if>



<g:if test="${'N'.contains(entityCode)}">
    <g:remoteLink controller="generics" action="quickEdit" id="${record.id}"
                  params="[entityCode: entityCode, field: 'pomegranate',
                          valueId: (record.pomegranate?.id ?: null), updateDiv: 'quickEditpomegranate' + record.id]"
                  update="quickEditpomegranate${record.id}"
                  title="ID ${record.syncedId ?: '?'} ${record.syncedOn ? ' on ' + record.syncedOn?.format('dd.MM.yyyy HH:mm') : ''}">
        <span id="quickEditpomegranate${record.id}"><span>${record.pomegranate?.code ? record.pomegranate?.code : 'No PKM'}</span> </span>
    </g:remoteLink>
</g:if>



<g:if test="${'CGR'.contains(entityCode)}">
    &nbsp;
    <g:remoteLink controller="generics" action="quickEdit" id="${record.id}"
                  params="[entityCode: entityCode, field: 'percentCompleted',
                          valueId: (record.percentCompleted ?: null), updateDiv: 'quickEditPercent' + record.id]"
                  update="quickEditPercent${record.id}"
                  title="Edit percent completed">
        <span id="quickEditPercent${record.id}">
        <span>${record.percentCompleted ? record.percentCompleted + '' : 'No %'}</span>
    </span>
    </g:remoteLink>

</g:if>


<g:if test="${record.class.declaredFields.name.contains('priority')}">
    <g:remoteLink controller="generics" action="quickEdit" id="${record.id}"
                  params="[entityCode: entityCode, field: 'priority',
                          valueId: (record.priority ?: null), updateDiv: 'quickEditPriority' + record.id]"
                  update="quickEditPriority${record.id}"
                  title="Edit priority ">
        <span id="quickEditPriority${record.id}"> <span>${record.priority ? '' + record.priority : 'No priority'}</span></span>
    </g:remoteLink>


</g:if>


</td>
<td class="record-statistics">
    <span title="Statistics">

        <g:if test="${params.action != 'luceneSearch'}">
            <g:if test="${entityCode == 'G'}">
                ${Planner.countByGoal(record)} <sup>P</sup>

                ${Task.countByGoal(record)} <sup>T</sup>

            </g:if>



            <g:if test="${entityCode == 'T'}">

                <g:remoteLink controller="task" action="showPlans" id="${record.id}"
                              update="below${entityCode}Record${record.id}"
                              title="Show plans">
                    ${Planner.countByTask(record)} <sup>P</sup>
                </g:remoteLink>

            </g:if>

            <g:if test="${entityCode == 'R' && record.resourceType == 'ebk'}">
                R <sup>${Excerpt.countByBook(mcs.Book.get(record.id))}</sup>
            %{--${IndexCard.countByBook(mcs.Book.get(record.id))} <sup>C</sup>--}%
            </g:if>

            <g:if test="${entityCode == 'K'}">
                # <i>${IndicatorData.countByIndicator(record)}</i>

            </g:if>

            <g:if test="${entityCode == 'Q'}">
            %{--# <sup>${PaymentData.countByCategory(record)}</sup>--}%
                %{--todo--}%
            </g:if>
        </g:if>
    </span>
</td>

<td class="record-date">
    <g:remoteLink controller="generics" action="showDetails"
                  params="${[id: record.id, entityCode: entityCode]}"
                  update="below${entityCode}Record${record.id}"
                  title="Date">

        <g:if test="${'R'.contains(entityCode)}">
            <g:if test="${record.publishedOn}">
                <pkm:weekDate date="${record?.publishedOn}"/>
            </g:if>
        </g:if>
        <g:elseif test="${'JP'.contains(entityCode)}">
            <span title="${record.startDate?.format('EE dd.MM.yyyy HH:mm')}">
                <span class="hour">${record.startDate?.format('HH')}</span>_<pkm:weekDate date="${record?.startDate}"/>
            </span>
            <g:if test="${record.endDate}">
            %{--<br/>--}%
                -
                <span title="${record.endDate?.format('EE dd.MM.yyyy HH:mm')}">
                    <span class="hour">${record.endDate?.format('HH')}</span>_<pkm:weekDate date="${record?.endDate}"/>
                </span>
            </g:if>
        %{--<br/>--}%
        %{--<pkm:weekDate date="${record?.endDate}"/>--}%
        </g:elseif>
        <g:elseif test="${'R'.contains(entityCode)}">

            ${record?.publicationDate ? record?.publicationDate?.substring(0, Math.min(4, record?.publicationDate?.length() - 1)) : ''}

        </g:elseif>
        <g:elseif test="${'I'.contains(entityCode)}">
            <pkm:weekDate date="${record?.date}"/>
        </g:elseif>
        <g:elseif test="${'Q'.contains(entityCode)}">
            <pkm:weekDate date="${record?.date}"/>
        </g:elseif>

        <g:else>
        %{--<prettytime:display date="${record?.dateCreated}"></prettytime:display>--}%
        %{--<pkm:weekDate date="${record?.dateCreated}"/>--}%
            ${record?.dateCreated?.format('dd.MM.yyyy')}
        </g:else>
    </g:remoteLink>
</td>






%{--<g:if test="${'CW'.contains(entityCode)}">--}%

    %{--<td class="actionTd">--}%

        %{--<g:link controller="page" action="publish" target="_blank"--}%
                %{--params="${[id: record.id, entityCode: entityCode]}"--}%
                %{--class=" fg-button fg-button-icon-solo ui-widget ui-state-default ui-corner-all"--}%
                %{--title="Publish">--}%
            %{--<span class="ui-icon ui-icon-script"></span>--}%
        %{--</g:link>--}%

        %{--<g:link controller="page" action="presentation" target="_blank"--}%
                %{--params="${[id: record.id, entityCode: entityCode]}"--}%
                %{--class=" fg-button fg-button-icon-solo ui-widget ui-state-default ui-corner-all"--}%
                %{--title="presentation">--}%
            %{--<span class="ui-icon ui-icon-script"></span>--}%

        %{--</g:link>--}%




    %{--</td>--}%


%{--</g:if>--}%





%{--<tdclass="actionTd">--}%
%{----}%
%{--</td>--}%

</tr>
</table>
</div>