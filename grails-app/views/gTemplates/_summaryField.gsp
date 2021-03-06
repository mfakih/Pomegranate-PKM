<%@ page import="mcs.Planner; mcs.Journal; mcs.Book; mcs.Writing; ker.OperationController" %>


<g:if test="${record.class.declaredFields.name.contains('goal')}">
    &nbsp;
    <g:set value="goal" var="field"></g:set>

    %{--<a href="#" id="${field}${record.id}" class="${field}" data-type="select" data-value="${record[field]?.id}"--}%
       %{--data-name="${field}-${entityCode}"--}%
       %{--style="border-bottom: 0.5px solid #808080; font-size: 11px; text-decoration: italic;  float: right; padding-right: 4px;"--}%
       %{--data-source="/pkm/operation/getQuickEditValues?entity=${entityCode}&field=${field}&date=${new Date().format('hhmmssDDMMyyyy')}"--}%
       %{--data-pk="${record.id}" data-url="/pkm/operation/quickSave2" data-title="Edit ${field}">--}%
        %{--${record[field] ? record[field]?.summary : ''}--}%
    %{--</a>--}%

    <g:if test="${record.goal}">
        <g:remoteLink controller="generics" action="showSummary" id="${record.goal?.id}"
                      params="[entityCode: 'G']"
                      update="below${entityCode}Record${record.id}"
                      title="Show goal">
            <i>d</i>
            <b>${record.goal?.department?.code}</b>
            <i>${record.goal?.summary}</i>

        </g:remoteLink>
        <br/>
    </g:if>




    &nbsp;
</g:if>


<g:if test="${entityCode == 'N' && record.recordId}">

    <g:remoteLink controller="generics" action="showSummary" id="${record.recordId}"
                  params="[entityCode: record.entityCode]"
                  update="below${entityCode}Record${record.id}"
                  title="Show parent entity">

        <b>${record.entityCode}</b>
        <i>${record.recordId}</i>

    </g:remoteLink>

    <br/>

</g:if>

<script>
    %{--$('#${field}${record.id}').editable();--}%
</script>



<g:if test="${record.class.declaredFields.name.contains('department')}">

   <b>${record?.department?.code}</b>

</g:if>




%{--<g:if test="${record.class.declaredFields.name.contains('course')}">--}%

    %{--<g:set value="course" var="field"></g:set>--}%

 %{--<span title="${record.course?.summary}"--}%
       %{--style="font-size: 11px; font-weight: bold; float: right; padding-right: 4px;">--}%
        %{--${record[field]?.code ?: ''}--}%
		%{--${record[field]?.codeString ?: ''}--}%
    %{--</span>--}%
    %{--<script>--}%
        %{--$('#${field}${record.id}').editable({--}%
        %{--//                     });--}%
    %{--</script>--}%

%{--</g:if>--}%



<g:remoteLink controller="page" action="panel"
              params="${[id: record.id, entityCode: entityCode]}"
              update="3rdPanel"
              before="jQuery('#accordionEast').accordion({ active: 0});"
              title="Go to page">




<g:if test="${record.class.declaredFields.name.contains('isPrivate')}">
    <g:if test="${record.isPrivate}">
        &notin;
    </g:if>
</g:if>







<g:if test="${record.class.declaredFields.name.contains('publishedOn') && record.publishedOn && record?.type?.code == 'nws'}">
    <span title="${record.publishedOn?.format(OperationController.getPath('datetime.format'))}" style="font-size: 11px; text-weight: bold;">
        ${record.publishedOn?.format(OperationController.getPath('date.format'))}
    </span>
</g:if>



<g:if test="${record.class.declaredFields.name.contains('startDate') && record.startDate}">
    <span title="${record.startDate?.format(OperationController.getPath('datetime.format'))}" style="font-size: 11px; text-weight: bold;">
        ${record.startDate?.format(OperationController.getPath('date.format'))}
    </span>
</g:if>

<g:if test="${record.class.declaredFields.name.contains('startDate') && record.startDate}">
    <span title="${record.startDate?.format(OperationController.getPath('datetime.format'))}" style="font-size: 11px; text-weight: bold;">
        ${record.startDate?.format(OperationController.getPath('date.format'))}
    </span>
</g:if>

<g:if test="${record.class.declaredFields.name.contains('endDate') && record.endDate}"  style="font-size: 11px; text-weight: bold;">
    <span title="${record.endDate?.format(OperationController.getPath('datetime.format'))}">
        >${record.endDate?.format(OperationController.getPath('date.format'))}
    </span>
    <br/>
</g:if>


<g:if test="${record.class.declaredFields.name.contains('completedOn') && record.completedOn}">
    <span title="${record.completedOn?.format(OperationController.getPath('datetime.format'))}"  style="font-size: 10px; font-style: italic;">
        .${record.completedOn?.format(OperationController.getPath('date.format'))}
    </span>
</g:if>







<g:if test="${record.class.declaredFields.name.contains('book') && record.book}">

    <g:remoteLink controller="generics" action="showSummary" id="${record.book?.id}"
                  params="[entityCode: 'R']"
                  update="below${entityCode}Record${record.id}"
        style="font-style: italic; font-size: 11px;"
                  title="Show book">
        ${record.book?.id}r
        <i>${record.book?.title}</i>
    </g:remoteLink>
    <br/>
</g:if>


<g:if test="${record.class.declaredFields.name.contains('course') && record.course}">

    <g:remoteLink controller="generics" action="showSummary" id="${record.course?.id}"
                  params="[entityCode: 'C']"
        style="font-size: 9px; text-style: italic; padding: 2px; color: #003366"
                  update="below${entityCode}Record${record.id}"
                  title="Show course">
        <b>${record.course?.code ?: record.course?.numberCode}</b>
        %{--<i>${record.course?.summary}</i>--}%
    </g:remoteLink>
      %{--<br/>--}%
</g:if>



%{--<g:remoteLink controller="generics" action="showDetails"--}%
%{--params="${[id: record.id, entityCode: entityCode]}"--}%
%{--update="below${entityCode}Record${record.id}"--}%
%{--title="Details">--}%

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




<g:if test="${record.class.declaredFields.name.contains('priority')}">
    <span style="font-size: 10px; color: gray">
        <g:if test="${record.priority == 3}">
            &gt;
        </g:if>
        <g:elseif test="${record.priority == 4}">
            <b>&gt;&gt;</b>
        </g:elseif>
        <g:elseif test="${record.priority == 1}">
            <b>&darr;</b>
        </g:elseif>
    </span>
</g:if>



<g:if test="${record.class.declaredFields.name.contains('summary')}">

<g:remoteLink  controller="page" action="panel"
               params="${[id: record.id, entityCode: entityCode]}"
               update="3rdPanel"
               style="padding: 2px; font-size: 14px;"
               before="jQuery('#accordionEast').accordion({ active: 0});">

    <g:if test="${!record.summary}">
        ...
    </g:if>
    <span title="${record.summary}">
        <g:if test="${entityCode == 'E'}">
            <br/>
        </g:if>

    %{--<bdi>--}%
        <pkm:summarize text="${record.summary}" length="80"/>
    %{--</bdi>--}%

    </span>
    </g:remoteLink>




</g:if>



<g:if test="${record.class.declaredFields.name.contains('writtenOn') && record.writtenOn}">

    <span style="font-size: 11px; font-weight: bold; float: right; padding-right: 4px;"
          title="${record.writtenOn?.format(OperationController.getPath('datetime.format'))}">
        <g:if test="${record.class.declaredFields.name.contains('approximateDate') && record.approximateDate}">
            ~
        </g:if>

        ${record.writtenOn?.format(OperationController.getPath('date.format'))}
    </span>
</g:if>


<g:if test="${record.class.declaredFields.name.contains('1111')}">
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

  <i style="float: right">
    <g:if test="${Planner.countByCourse(record) > 0}">
        ${Planner.countByCourse(record)}p
    </g:if>
    <g:if test="${Journal.countByCourse(record) > 0}">
        ${Journal.countByCourse(record)}j
    </g:if>
  </i>


</g:if>




%{--<g:if test="${entityCode == 'D'}">--}%
%{--<b>${record.code}</b>--}%
%{--${record.name}--}%
%{--</g:if>--}%


<g:if test="${'N'.contains(entityCode)}">
    <g:if test="${record.fileName}">
        <a href="${createLink(controller: 'operation', action: 'downloadNoteFile', id: record.id)}" target="_blank">
            <span style="font-size: 10px; font-style: italic; text-decoration: underline">
                ${record.fileName}
            </span>
        </a>
    </g:if>



    <g:if test="${record.source}">
        <i style="font-size: smaller"><pkm:summarize text="${record.source}" length="30"/></i>
    </g:if>


    <g:if test="${record.sourceFree}">
        <i style="font-size: smaller"><pkm:summarize text="${record.sourceFree}" length="30"/></i>
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




%{--<g:if test="${record.class.declaredFields.name.contains('notes') && record.notes}">--}%
%{--<span style="color:#7588b2 ">--}%
%{--${record.notes}--}%
%{--</span>--}%
%{--</g:if>--}%



<g:if test="${record.class.declaredFields.name.contains('readOn') && record.readOn}">
    <img src="${resource(dir: '/css/images', file: 'edx-check.png')}" style="width: 15px;"
         title="${record.readOn?.format('dd.MM.yyyy')}"/>
%{--Read ${record.readOn?.format('dd.MM.yyyy')}--}%
</g:if>

<g:if test="${record.class.declaredFields.name.contains('reviewCount') && record.reviewCount}">
   <sup> ${record.reviewCount}</sup>
</g:if>

<g:if test="${record.class.declaredFields.name.contains('chapters') && record.chapters}">
    &nbsp; -
     ch ${record.chapters}
</g:if>



<g:if test="${entityCode == 'R'}">

%{--<bdi>--}%


<g:remoteLink  controller="page" action="panel"
               params="${[id: record.id, entityCode: entityCode]}"
               update="3rdPanel"
               style="padding: 2px; font-size: 14px;"
               before="jQuery('#accordionEast').accordion({ active: 0});">

    <pkm:summarize text="${(record.title ?: '') + ' ' + (record.author ?: '')}" length="100"/>

%{--</bdi>--}%
    <g:if test="${!record.title && record.legacyTitle}">
        _ <i>${record.legacyTitle}</i>
    </g:if>

    <g:if test="${record.url}">

        <a style="font-size: smaller" href="${record.url}" target="_blank"><pkm:summarize text="${record.url}" length="30"/></a>
    </g:if>


    <g:if test="${record.class.declaredFields.name.contains('publicationDate') && record.publicationDate}">
        <span style="font-size: 11px; text-weight: bold;">
            &nbsp;    ${record.publicationDate}
        </span>
    </g:if>
    
    </g:remoteLink>

</g:if>



<g:if test="${'JP'.contains(entityCode)}">
    <g:if test="${record.level}">
    %{--<div style="display: inline; padding: 2px; margin: 3px;" class="record-level level${record.level}"--}%
    %{--title="Level">--}%
        l<sup>${record.level}</sup>
    %{--</div>--}%

    </g:if>
</g:if>


<g:if test="${'J'.contains(entityCode) && new File(OperationController.getPath('jrn.sns.path') + '/J/' + record.id).exists()}">
       <b style="color: darkgreen">sns</b> &nbsp;
</g:if>

<g:if test="${'J'.contains(entityCode) && new File(OperationController.getPath('jrn.rcd.path') + '/J/' + record.id).exists()}">
       <b style="color: darkgreen">rcd</b> &nbsp;
</g:if>
<g:if test="${'J'.contains(entityCode) && new File(OperationController.getPath('jrn.vjr.path') + '/J/' + record.id).exists()}">
       <b style="color: darkgreen">vjr</b> &nbsp;
</g:if>






<g:if test="${record.class.declaredFields.name.contains('excerpt') && record.excerpt}">

    <g:remoteLink controller="generics" action="showSummary" id="${record.excerpt.id}"
                  params="[entityCode: 'R']"
                  update="below${entityCode}Record${record.id}"
                  title="Go to record">
        <b>E-${record.excerpt?.title}</b>
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
    <g:if test="${record.class.declaredFields.name.contains('summary') && record.summary}">
        <br/>
    </g:if>
	
	

    <g:if test="${params.action == 'record' && record.entityCode() == 'N'}">
        ${record?.description?.replaceAll("\\<.*?>", "")?.replaceAll('\n', '<br/>')?.decodeHTML()?.replaceAll('\n', '<br/>')?.replace('Product Description', '')}
    </g:if>
    <g:else>
        <g:if test="${record.class.declaredFields.name.contains('language')}">
            <div class="text${record.language}">
        </g:if>
        <div style="font-size: 13px; color: #4A5C69; padding: 3px;">
            <g:if test="${record.description?.length() < 250}">
                ${record?.description?.replaceAll("\\<.*?>", "")?.replaceAll('\n', '<br/>')?.decodeHTML()?.replaceAll('\n', '<br/>')?.replace('Product Description', '')}
            </g:if>
            <g:else>
            <pkm:summarize text="${record?.description?.replace('Product Description', '')?.replaceAll("\\<.*?>", "")}"
                           length="200"/>
            </g:else>
        </div>
        <g:if test="${record.class.declaredFields.name.contains('language')}">
            </div>
        </g:if>
    </g:else>



</g:if>



	<g:if test="${record.class.declaredFields.name.contains('fullText')}">
	 <span style="font-size: 11px; font-style: italic; color: #8A5C69">
         <pkm:summarize text="${record.fullText}" length="200"/>
    </span>
	</g:if>
	
	
	<g:if test="${record.class.declaredFields.name.contains('password')}">
	 <span style="font-size: 12px; color: #8A5C69">
         ${record.password}
    </span>
	</g:if>
	

%{--<g:if test="${record.class.declaredFields.name.contains('query')}">--}%
%{--${record.query}--}%
%{--</g:if>--}%
%{--<g:if test="${record.class.declaredFields.name.contains('countQuery')}">--}%
%{--${record.countQuery}--}%
%{--</g:if>--}%

%{--</g:remoteLink>--}%






<g:if test="${'N'.contains(entityCode)}">

%{--<g:if test="${record.book}">--}%

%{--<g:remoteLink controller="generics" action="showSummary" id="${record.book.id}"--}%
%{--params="[entityCode: 'R']"--}%
%{--update="below${entityCode}Record${record.id}"--}%
%{--title="Show book">--}%
%{--~ R-${record.book.id} ${record.book.title}.--}%
%{--</g:remoteLink>--}%
%{--</g:if>--}%
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

</g:remoteLink>

%{--</span>--}%

<g:if test="${record.class.declaredFields.name.contains('tags')}">
    &nbsp; <g:render template="/tag/tags" model="[instance: record, entity: entityCode]"/>

</g:if>
<g:if test="${record.class.declaredFields.name.contains('contacts')}">
    &nbsp; <g:render template="/tag/contacts" model="[instance: record, entity: entityCode]"/>
</g:if>


