<%@ page import="ker.OperationController" %>
<g:if test="${entityCode == 'T'}">


    <g:if test="${record.priority == 3}">
       &gt;
    </g:if>
    <g:elseif test="${record.priority == 4}">
              <b>&gt;&gt; </b>
    </g:elseif>
   <g:elseif test="${record.priority == 1}">
              <b>&darr; </b>
    </g:elseif>


    <g:if test="${record.goal}">
        <g:remoteLink controller="generics" action="showSummary" id="${record.goal?.id}"
                      params="[entityCode: 'G']"
                      update="below${entityCode}Record${record.id}"
                      title="Show goal">
            <span style="color: #004499; font-weight: bold">
                ${record.goal?.summary}</span>
        </g:remoteLink>
    </g:if>

    <pkm:summarize text="${record.summary}" length="80"/>

    <span style="font-size: 12px; font-style: italic; color: #4A5C69">
        <pkm:summarize text="${record?.description?.replace('Product Description', '')?.replaceAll("\\<.*?>", "")}"
                       length="60"/>
    </span>

    <span style="${record.status?.style} ; border: 0.5px solid; float: right; border-radius: 3px; padding: 1px;">
        ${record.status?.name}
    </span>

        <g:if test="${record.orderInCourse}">
            <span styl="font-size: 12px;">#${record.orderInCourse}</span>
        </g:if>



    <span style="color:#7588b2 ">
        ${record.notes}
    </span>

    &nbsp; <g:render template="/tag/tags" model="[instance: record, entity: entityCode]"/>



</g:if>
<g:else>



<g:if test="${record.class.declaredFields.name.contains('goal') && record.goal}">
    <g:remoteLink controller="generics" action="showSummary" id="${record.goal?.id}"
                  params="[entityCode: 'G']"
                  update="below${entityCode}Record${record.id}"
                  title="Show goal">
        <span style="color: #004499; font-weight: bold">
            ${record.goal?.summary}</span>
    </g:remoteLink>

</g:if>




<g:if test="${record.class.declaredFields.name.contains('startDate') && record.startDate}">
    ${record.startDate?.format(OperationController.getPath('date.format'))}
</g:if>






<g:if test="${record.class.declaredFields.name.contains('book') && record.book}">

    <g:remoteLink controller="generics" action="showSummary" id="${record.book?.id}"
                  params="[entityCode: 'R']"
                  update="below${entityCode}Record${record.id}"
                  title="Show book">
        ${record.book?.id}b
        <b>${record.book?.title}</b>
    </g:remoteLink>

</g:if>



<g:remoteLink controller="generics" action="showDetails"
              params="${[id: record.id, entityCode: entityCode]}"
              update="below${entityCode}Record${record.id}"
              title="Details">

<g:if test="${record.class.declaredFields.name.contains('code') && record.code}">
    <span style="color: #004499; font-family: monospace">${record.code}</span>
</g:if>
<g:if test="${record.class.declaredFields.name.contains('slug') && record.slug}">
    <span style="color: #004499; font-family: monospace">${record.slug}</span>
</g:if>


<g:if test="${record.class.declaredFields.name.contains('entity')}">
    <span title="${record.entity}">
        <i>${record.entity}</i>
    </span>

</g:if>


<g:if test="${record.class.declaredFields.name.contains('summary')}">
    <span title="${record.summary}">
        <g:if test="${entityCode == 'E'}">
            <br/>
        </g:if>
        <pkm:summarize text="${record.summary}" length="80"/>

    </span>

</g:if>

<g:if test="${record.class.declaredFields.name.contains('1')}">
    <span title="${record.code}">
        ${record.code}
    </span>

</g:if>

<g:if test="${record.class.declaredFields.name.contains('name')}">
    <span title="${record.name}">
        <b>${record.name}</b>
    </span>

</g:if>


<g:if test="${record.class.declaredFields.name.contains('value')}">
    <span title="${record.value}">
        <i>${record.value}</i>
    </span>

</g:if>


<g:if test="${entityCode == 'C'}">
    <b>${record.numberCode}</b>
</g:if>




%{--<g:if test="${entityCode == 'D'}">--}%
%{--<b>${record.code}</b>--}%
%{--${record.name}--}%
%{--</g:if>--}%


<g:if test="${'N'.contains(entityCode)}">
    <g:if test="${record.fileName}">
        <a href="${createLink(controller: 'attachment', action: 'download', id: record.id)}" target="_blank">
            <span style="font-size: 12px;">
                ${record.fileName}
            </span></a>
    </g:if>

    <g:if test="${record.sourceFree}">
        ${record.sourceFree}
    </g:if>
    <g:if test="${record.source}">
        <span style="color: brown">${record.source}</span>
    </g:if>
    <g:if test="${!record.summary}">

        Untitled
    </g:if>

%{--<g:if test="${!record.summary}">--}%
%{--<i style="font-size: smaller"> <pkm:summarize text="${record.description}" length="80"/></i>--}%
%{--</g:if>--}%

</g:if>


%{--<g:if test="${record.class.declaredFields.name.contains('title')}">--}%
%{--${record.source}:--}%
%{--<span style="font-family: tahoma;">--}%
%{--<b>${record.title}</b>--}%
%{--</span>--}%
%{--</g:if>--}%

<g:if test="${record.class.declaredFields.name.contains('reality') && record.reality}">
    <span style="color:#b22222 ">
        ${record.reality}
    </span>
</g:if>


<g:if test="${record.class.declaredFields.name.contains('trackSequence') && record.trackSequence}">
    <b>${record.trackSequence}</b>
</g:if>




<g:if test="${record.class.declaredFields.name.contains('notes') && record.notes}">
    <span style="color:#7588b2 ">
        ${record.notes}
    </span>
</g:if>



<g:if test="${record.class.declaredFields.name.contains('readOn') && record.readOn}">
    <img src="${resource(dir: '/css/images', file: 'edx-check.png')}" style="width: 15px;"
         title="${record.readOn?.format('dd.MM.yyyy')}"/>
%{--Read ${record.readOn?.format('dd.MM.yyyy')}--}%
</g:if>

<g:if test="${record.class.declaredFields.name.contains('chapters') && record.chapters}">
    &nbsp; -
     ch ${record.chapters}
</g:if>



<g:if test="${entityCode == 'R'}">

    <pkm:summarize text="${(record.title ?: '') + ' ' + (record.author ?: '')}" length="100"/>

    <g:if test="${!record.title && record.legacyTitle}">
        _ ${record.legacyTitle}
    </g:if>

    <g:if test="${record.url}">
        ${record.url}
    </g:if>
</g:if>



<g:if test="${'JP'.contains(entityCode)}">
    <g:if test="${record.level}">
    %{--<div style="display: inline; padding: 2px; margin: 3px;" class="record-level level${record.level}"--}%
    %{--title="Level">--}%
        l<sup>${record.level}</sup>
    %{--</div>--}%

    </g:if>
</g:if>






<g:if test="${record.class.declaredFields.name.contains('excerpt') && record.excerpt}">

    <g:remoteLink controller="generics" action="showSummary" id="${record.excerpt.id}"
                  params="[entityCode: 'R']"
                  update="below${entityCode}Record${record.id}"
                  title="Go to record">
        <b>E-${record.excerpt?.title}</b>
    </g:remoteLink>

</g:if>




<g:if test="${record.class.declaredFields.name.contains('task') && record.task}">

    <g:remoteLink controller="generics" action="showSummary" id="${record.task.id}"
                  params="[entityCode: 'T']"
                  update="below${entityCode}Record${record.id}"
                  title="Show task">
        <b style="color: #555555; font-size: 12px;">
        %{--${record.task?.parentGoal?.code?.toUpperCase()}--}%
            T-${record.task.id} <pkm:summarize text="${record.task?.summary}" length="80"/></b>

    </g:remoteLink>

</g:if>

<g:if test="${record.class.declaredFields.name.contains('goal') && record.goal}">
    <g:remoteLink controller="generics" action="showSummary" id="${record.goal.id}"
                  params="[entityCode: 'G']"
                  update="below${entityCode}Record${record.id}"
                  title="Show goal">
        <i>G-${record.goal?.id}</i>
        <span style="color: #555555; font-weight: bold">${record.goal?.summary}</span>

    </g:remoteLink>

</g:if>





<g:if test="${entityCode == 'R' && record.isPublic}">
    <span>shared</span>
</g:if>


<g:if test="${context}">
    ${context} <br/>
</g:if>


<g:if test="${record.class.declaredFields.name.contains('shortDescription')}">
    <span style="font-size: 12px; font-style: italic; color: #4A5C69">
        <pkm:summarize text="${record?.shortDescription?.replaceAll("\\<.*?>", "")}"
                       length="60"/>
    </span>
</g:if>


<g:if test="${record.class.declaredFields.name.contains('description')}">
    <span style="font-size: 12px; font-style: italic; color: #4A5C69">
        <pkm:summarize text="${record?.description?.replace('Product Description', '')?.replaceAll("\\<.*?>", "")}"
                       length="60"/>
    </span>
</g:if>



%{--<g:if test="${record.class.declaredFields.name.contains('query')}">--}%
%{--${record.query}--}%
%{--</g:if>--}%
%{--<g:if test="${record.class.declaredFields.name.contains('countQuery')}">--}%
%{--${record.countQuery}--}%
%{--</g:if>--}%

</g:remoteLink>






<g:if test="${'N'.contains(entityCode)}">

    <g:if test="${record.book}">

        <g:remoteLink controller="generics" action="showSummary" id="${record.book.id}"
                      params="[entityCode: 'R']"
                      update="below${entityCode}Record${record.id}"
                      title="Show book">
            ~ R-${record.book.id} ${record.book.title}.
        </g:remoteLink>
    </g:if>
    <g:if test="${record.pages}">
        <i>pg. ${record.pages}</i>
    </g:if>
</g:if>



<span style="float: right;">
    <g:if test="${record.class.declaredFields.name.contains('orderInCourse')}">
        <g:if test="${record.orderInCourse}">
            <span styl="font-size: 12px;">#${record.orderInCourse}</span>
        </g:if>
    </g:if>
</span>
<g:if test="${'CGR'.contains(entityCode) && record.percentCompleted}">
    <pkm:progressBar percent="${record.percentCompleted}"/>
</g:if>

%{--</span>--}%

<g:if test="${record.class.declaredFields.name.contains('tags')}">
    &nbsp; <g:render template="/tag/tags" model="[instance: record, entity: entityCode]"/>
</g:if>
<g:if test="${'T'.contains(entityCode)}">
    &nbsp; <g:render template="/tag/peopleTags" model="[instance: record, entity: entityCode]"/>
</g:if>

    <br/>
<g:if test="${record.class.declaredFields.name.contains('status')}">
    <span style="${record.status?.style} ; border: 0.5px solid;  border-radius: 3px; padding: 1px; margin-right: 3px;">
        ${record.status?.name}
    </span>
</g:if>
<g:if test="${record.class.declaredFields.name.contains('type')}">
    <span style="${record.type?.style} ; border: 0.5px solid;  border-radius: 3px;  padding: 1px;  margin-right: 3px;">
        ${record.type?.name}
    </span>
</g:if>
</g:else>