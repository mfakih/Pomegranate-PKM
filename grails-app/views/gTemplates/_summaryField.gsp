<%@ page import="ker.OperationController" %>
<g:if test="${entityCode == '11111111'}">


    <g:if test="${record.priority == 3}">
       &gt;
    </g:if>
    <g:elseif test="${record.priority == 4}">
              <b>&gt;&gt; </b>
    </g:elseif>
   <g:elseif test="${record.priority == 1}">
              <b>&darr; </b>
    </g:elseif>




    <pkm:summarize text="${record.summary}" length="80"/>

    <span style="font-size: 12px; font-style: italic; color: #4A5C69">
        <pkm:summarize text="${record?.description?.replace('Product Description', '')?.replaceAll("\\<.*?>", "")}"
                       length="60"/>
    </span>

    <span style="${record.status?.style}; font-size: 11px; border: 0px solid; text-decoration: #808080 underline;  border-radius: 3px; padding: 1px; margin-right: 3px;">
        ${record.status?.code}
    </span>




        <g:if test="${record.orderInCourse}">
            <span styl="font-size: 12px;">#${record.orderInCourse}</span>
        </g:if>



    <span style="color:#7588b2 ">
        ${record.notes}
    </span>

    <g:if test="${record.class.declaredFields.name.contains('tags')}">
        &nbsp; <g:render template="/tag/tags" model="[instance: record, entity: entityCode]"/>
        &nbsp; <g:render template="/tag/contacts" model="[instance: record, entity: entityCode]"/>
    </g:if>

</g:if>
<g:else>

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





<g:if test="${record.class.declaredFields.name.contains('type') && entityCode.length() == 1}">
    <g:set value="type" var="field"></g:set>

    <a href="#" id="${field}${record.id}" class="${field}" data-type="select" data-value="${record[field]?.id}"
       style="${record.type ? record.type?.style : ''};font-size: 11px; font-weight: bold"
       data-name="${field}-${entityCode}"
       data-source="/pkm/operation/getQuickEditValues?entity=${entityCode}&field=${field}&date=${new Date().format('hhmmssDDMMyyyy')}"
       data-pk="${record.id}" data-url="/pkm/operation/quickSave2" data-title="Edit ${field}">
        ${record[field]?.code ?: 'No ' + field}
    </a>
    <script>
        $('#${field}${record.id}').editable();
    </script>
</g:if>





<g:if test="${record.class.declaredFields.name.contains('startDate') && record.startDate}">
    <span title="${record.startDate?.format(OperationController.getPath('datetime.format'))}">
    ${record.startDate?.format(OperationController.getPath('date.format'))}
    </span>
</g:if>


<g:if test="${record.class.declaredFields.name.contains('book') && record.book}">

    <g:remoteLink controller="generics" action="showSummary" id="${record.book?.id}"
                  params="[entityCode: 'R']"
                  update="below${entityCode}Record${record.id}"
                  title="Show book">
        ${record.book?.id}b
        <i>${record.book?.title}</i>
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

        %{--<bdi>--}%
            <pkm:summarize text="${record.summary}" length="80"/>
        %{--</bdi>--}%

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
        <a href="${createLink(controller: 'operation', action: 'downloadNoteFile', id: record.id)}" target="_blank">
            <span style="font-size: 12px;">
                ${record.fileName}
            </span></a>
    </g:if>


  
    <g:if test="${record.source}">        
        <i style="font-size: smaller"><pkm:summarize text="${record.source}" length="30"/></i>
    </g:if>
    <g:if test="${!record.summary}">

        Untitled
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

<g:if test="${record.class.declaredFields.name.contains('chapters') && record.chapters}">
    &nbsp; -
     ch ${record.chapters}
</g:if>



<g:if test="${entityCode == 'R'}">

    %{--<bdi>--}%
    <pkm:summarize text="${(record.title ?: '') + ' ' + (record.author ?: '')}" length="100"/>

    %{--</bdi>--}%
    <g:if test="${!record.title && record.legacyTitle}">
        _ ${record.legacyTitle}
    </g:if>

    <g:if test="${record.url}">
        
        <i style="font-size: smaller"><pkm:summarize text="${record.url}" length="30"/></i>
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





<g:if test="${record.class.declaredFields.name.contains('writing') && entityCode == 'N'}">
    <g:set value="writing" var="field"></g:set>

    <a href="#" id="${field}${record.id}" class="${field}" data-type="select" data-value="${record[field]?.id}"
       data-name="${field}-${entityCode}"
       style="border-bottom: 0.5px solid #808080; font-size: 11px; text-decoration: italic"
       data-source="/pkm/operation/getQuickEditValues?entity=${entityCode}&field=${field}&date=${new Date().format('hhmmssDDMMyyyy')}"
       data-pk="${record.id}" data-url="/pkm/operation/quickSave2" data-title="Edit ${field}">
        ${record[field] ? record[field]?.summary : 'No ' + field}
    </a>
    <script>
        $('#${field}${record.id}').editable();
    </script>

</g:if>

<g:if test="${record.class.declaredFields.name.contains('goal')}">
    &nbsp;
    <g:set value="goal" var="field"></g:set>

    <a href="#" id="${field}${record.id}" class="${field}" data-type="select" data-value="${record[field]?.id}"
       data-name="${field}-${entityCode}"
       style="border-bottom: 0.5px solid #808080; font-size: 11px; text-decoration: italic"
       data-source="/pkm/operation/getQuickEditValues?entity=${entityCode}&field=${field}&date=${new Date().format('hhmmssDDMMyyyy')}"
       data-pk="${record.id}" data-url="/pkm/operation/quickSave2" data-title="Edit ${field}">
        ${record[field] ? record[field]?.summary : 'g'}
    </a>

            <g:if test="${record.goal}">
                <g:remoteLink controller="generics" action="showSummary" id="${record.goal?.id}"
                              params="[entityCode: 'G']"
                              update="below${entityCode}Record${record.id}"
                              title="Show goal">
                    <i>G-${record.goal?.id}</i>
                </g:remoteLink>
            </g:if>

    <script>
        $('#${field}${record.id}').editable();
    </script>

    &nbsp;
</g:if>



<g:if test="${record.class.declaredFields.name.contains('course')}">

    <g:set value="course" var="field"></g:set>

    <a href="#" id="${field}${record.id}" class="${field}"

       data-type="select" data-value="${record[field]?.id}"

       data-name="${field}-${record.entityCode()}"
       data-source="/pkm/operation/getQuickEditValues?entity=${record.entityCode()}&field=${field}&date=${new Date().format('hhmmssMMyyyydd')}"
       data-pk="${record.id}" data-url="/pkm/operation/quickSave2" data-title="Edit ${field}"
       style="font-size: 11px; font-weight: bold;">
        ${record[field]?.code ?: '?'}

    </a>
    <script>
        $('#${field}${record.id}').editable({
//            typeahead: {
//                name: 'value'
//            }
        });
    </script>

</g:if>



<g:if test="${record.class.declaredFields.name.contains('status')}">
    <g:set value="status" var="field"></g:set>

    <a href="#" id="${field}${record.id}" class="${field}" data-type="select" data-value="${record[field]?.id}"
       data-name="${field}-${entityCode}"
       style="${record.status ? record.status?.style : ''}; float: right; border: 0.5px solid #808080; border-radius: 3px; font-size: 11px; text-decoration: italic; padding-left: 2px; padding-right: 2px;"
       data-source="/pkm/operation/getQuickEditValues?entity=${entityCode}&field=${field}&date=${new Date().format('hhmmssDDMMyyyy')}"
       data-pk="${record.id}" data-url="/pkm/operation/quickSave2" data-title="Edit ${field}">
        ${record[field] ? record[field]?.code : 'No ' + field}
    </a>
    <script>
        $('#${field}${record.id}').editable();
    </script>

</g:if>

<span style="float: right;">
    <g:if test="${record.class.declaredFields.name.contains('orderInCourse')}">
        <g:if test="${record.orderInCourse}">
            <span styl="font-size: 12px;">#${record.orderInCourse}</span>
        </g:if>
    </g:if>
</span>





%{--</span>--}%

<g:if test="${record.class.declaredFields.name.contains('tags')}">
    &nbsp; <g:render template="/tag/tags" model="[instance: record, entity: entityCode]"/>

    </g:if>
    <g:if test="${record.class.declaredFields.name.contains('contacts')}">
    &nbsp; <g:render template="/tag/contacts" model="[instance: record, entity: entityCode]"/>
</g:if>


</g:else>