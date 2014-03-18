<%@ page import="ker.OperationController; mcs.Writing; mcs.Book; cmn.Setting; org.apache.commons.lang.StringEscapeUtils; app.Payment; app.IndicatorData; app.IndexCard; mcs.Excerpt; java.text.DecimalFormat; mcs.parameters.WorkStatus; mcs.Goal; mcs.parameters.JournalType; mcs.Journal; mcs.Planner; mcs.Task" %>

<!-- gTemplates/recordSummary -->

%{--${grailsApplication.config.dataSource.dialect.name}--}%

<g:hasErrors bean="${record}">
    <div class="errors" xmlns="http://www.w3.org/1999/html" xmlns="http://www.w3.org/1999/html">
        <g:renderErrors bean="${record}" as="list"/>
    </div>
</g:hasErrors>


<g:if test="${record?.id}">

<g:set var="entityCode"
       value="${record.metaClass.respondsTo(record, 'entityCode') ? record.entityCode() : record.class?.name?.split(/\./).last()}"/>


<div id="${entityCode}Record${record.id}">

%{--${justUpdated ? 'justUpdated' : ''} todo--}%

<div class="recordContainer"
     style="background: #f2f2f2;  box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.2); padding: 0px;  margin: 3px; border-radius: 2px; margin-top: 15px;">

<table class="fixed-layout recordLine">
<tbody>

<tr style="background: #f5f5f5 !important">

<td class="record-id" style="width: 15px">

%{--<g:remoteLink controller="generics" action="toggleSelection"--}%
%{--params="${[id: record.id, entityCode: (record.class.declaredFields.name.contains('entityCode') ? record.entityCode : record.class.name)]}"--}%
%{--update="${(record.class.declaredFields.name.contains('entityCode') ? record.entityCode : record.class.name)}Record${record.id}"--}%
%{--title="Edit">--}%
%{--<g:if test="${session['record' + (record.class.declaredFields.name.contains('entityCode') ? record.entityCode : record.class.name) + record.id] == '1'}">--}%
%{--<i><b style="font-size: 10px;">${(record.class.declaredFields.name.contains('entityCode') ? record.entityCode : record.class.name)}</b></i>--}%
%{--</g:if>--}%
%{--<g:else>--}%

    <g:remoteLink controller="generics" action="showSummary"
                  params="${[id: record.id, entityCode: entityCode]}"
                  update="${entityCode}Record${record.id}"
                  title="ID ${record.id}. Click to refresh">

        <span class="${entityCode}-bkg ID-bkg ${record.class.declaredFields.name.contains('deletedOn') && record.deletedOn ? 'deleted' : ''}" style="padding: 3px; margin-right: 3px; color: gray;">
              <b style="color: white;">  ${entityCode}</b>
        </span>

    </g:remoteLink>
    %{--<sup style="color: #6E6E6E; font-size: 10px; padding-top: 3px;">${record.id}</sup>--}%

%{--</g:else>--}%



%{--</g:remoteLink>--}%

</td>
%{--<g:if test="${record.class.declaredFields.name.contains('summary')}">--}%


<td class="record-selection">

    <g:checkBox name="select-${record.id}-${entityCode}" title="Select record" class="acheckbox"
                value="${session[entityCode + record.id] == 1}"
                onchange="jQuery('#logRegion').load('generics/selectOnly/${entityCode}${record.id}')"
                onclick="jQuery('#logRegion').load('generics/selectOnly/${entityCode}${record.id}')"/>
    <!--a style="width: 10px; color: #000000"
           onclick="jQuery('#below${entityCode}Record${record.id}').html('')">&chi;</a-->

</td>


<td colspan="10" class="record-summary ${record.class.declaredFields.name.contains('status') && record.status ? 'status-' + record?.status?.code: ''}"
    style="font-family: Arial; width: 90% !important;: font-size: 14px; color: #105CB6; line-height: 20px; ">



    <g:if test="${record.class.declaredFields.name.contains('goal') && record.goal}">
        <g:remoteLink controller="generics" action="showSummary" id="${record.goal?.id}"
                      params="[entityCode: 'G']"
                      update="below${entityCode}Record${record.id}"
                      title="Show goal">
            <span style="color: #004499; font-weight: bold">
            ${record.goal?.summary}</span>
        </g:remoteLink>

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
      <i>  ${record.value}</i>
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

</g:if>



<g:if test="${'JP'.contains(entityCode)}">
    <g:if test="${record.level}">
        %{--<div style="display: inline; padding: 2px; margin: 3px;" class="record-level level${record.level}"--}%
             %{--title="Level">--}%
            l<sup>${record.level}</sup>
        %{--</div>--}%

    </g:if>
</g:if>




<g:if test="${record.class.declaredFields.name.contains('startDate') && record.startDate}">
    ${record.startDate?.format(OperationController.getPath('date.format'))}
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



</td>

%{--</td>--}%



<td class="actionTd" style="${justUpdated ? 'background: YellowGreen !important' : ''}">
    <g:remoteLink controller="generics" action="getAddForm" id="${record.id}"
                  params="[entityController: record.class.name,
                          updateRegion:  entityCode + 'Record' + record.id,
                          finalRegion: entityCode + 'Record' + record.id]"
                  class="fg-button fg-button-icon-solo ui-widget ui-state-default ui-corner-all"
                  update="${entityCode}Record${record.id}"
                  title="Edit">
        <span class="ui-icon ui-icon-pencil"></span>
    </g:remoteLink>
</td>
<td class="actionTd">

%{--<span style="float: right">--}%
<a class="fg-button fg-button-icon-solo ui-widget ui-state-default ui-corner-all"
   onclick="jQuery('#appendRow${entityCode}-${record.id}').removeClass('navHidden'); jQuery('#appendTextFor${entityCode}${record.id}').select(); jQuery('#appendTextFor${entityCode}${record.id}').focus();">
    <span class="ui-icon ui-icon-arrowreturn-1-e"></span>
</a>
  </td>





<td class="actionTd">
<g:if test="${record.class.declaredFields.name.contains('bookmarked')}">
    <g:if test="${!record.bookmarked}">
        <a name="bookmark${record.id}${entityCode}" title="Toggle bookmark"
           value="${record.bookmarked}"
           onclick="jQuery('#${entityCode}Record${record.id}').load('generics/quickBookmark/${entityCode}-${record.id}')">
            <span class="icon-star-gm"></span>
        </a>
    </g:if>

    <g:if test="${record.bookmarked}">
        <a name="bookmark${record.id}${entityCode}" title="Toggle bookmark"
           value="${record.bookmarked}"
           onclick="jQuery('#${entityCode}Record${record.id}').load('generics/quickBookmark/${entityCode}-${record.id}')">
            <span class="icon-starred-gm"></span>
        </a>

    </g:if>
    </g:if>

</td>



<g:if test="${entityCode == 'R' && record?.type?.code == 'ebk'}">

    <td>
        <g:if test="${(new File(OperationController.getPath('covers.sandbox.path') + '/' +
                record?.type?.code + '/' + record.id + '.jpg')?.exists() || new File(OperationController.getPath('covers.repository.path') + '/' + record?.type?.code + '/' + record.id + '.jpg')?.exists())}">

            <a href="${createLink(controller: 'book', action: 'viewImage', id: record.id)}"
               target="_blank">
                <img class="Photo" style="width: 30px; height:40px; display:inline"
                     src="${createLink(controller: 'book', action: 'viewImage', id: record.id, params: [date: new Date()])}"/>
            </a>
        </g:if>

    </td>
</g:if>



<g:if test="${entityCode == 'E'}">

    <td>
        <g:if test="${(new File(OperationController.getPath('covers.sandbox.path') + '/' +
                record?.book?.type?.code + '/' + record?.book?.id + '.jpg')?.exists() || new File(OperationController.getPath('covers.repository.path') + '/' + record?.book?.type?.code + '/' + record?.book?.id + '.jpg')?.exists())}">

            <a href="${createLink(controller: 'book', action: 'viewImage', id: record?.book?.id)}"
               target="_blank">
                <img class="Photo" style="width: 30px; height:40px; display:inline"
                     src="${createLink(controller: 'book', action: 'viewImage', id: record?.book?.id, params: [date: new Date()])}"/>
            </a>
        </g:if>

    </td>
</g:if>

</tr>

<tr id="appendRow${entityCode}-${record.id}" class="navHidden">
    <td colspan="13">

        <g:if test="${record.class.declaredFields.name.contains('description')}">
            <g:formRemote name="appendText" url="[controller: 'generics', action: 'appendText']"
                          update="${entityCode}Record${record.id}"
                          style="display: inline;">
                <g:hiddenField name="id" value="${record.id}"/>
                <g:hiddenField name="entityCode" value="${entityCode}"/>
                <g:textField id="appendTextFor${entityCode}${record.id}" name="text" class="ui-corner-all" cols="80"
                             placeholder="Append to description..."
                             rows="5"
                             style="width:98%;  display: inline; " value=""/>
                <g:submitButton name="add" value="+=" style="dispaly:none;"
                                class="fg-button ui-widget ui-state-default ui-corner-all navHidden"/>
            </g:formRemote>
        </g:if>

    </td>
</tbody>
</table>


<g:if test="${session['showLine1Only'] == 'off'}">
   <g:render template="/gTemplates/2ndLine" model="[record: record, entityCode: entityCode]"/>
</g:if>

<g:if test="${1 == 2}">
    <g:if test="${context || 'CRW'.contains(entityCode)}">
        <tr style="background: #f6f6f6 !important">
            <td colspan="12" style="font-size: 12px; font-style: normal; padding-bottom: 10px; padding-left: 30px;">
                <g:if test="${context}">
                    ${context} <br/>
                </g:if>


                <pkm:summarize text="${record.description?.replace('Product Description', '')}" length="300"/>



                <g:if test="${'T'.contains(entityCode)}">
                    <g:if test="${record.goal}">
                        <g:remoteLink controller="generics" action="showSummary" id="${record.goal.id}"
                                      params="[entityCode: 'G']"
                                      update="below${entityCode}Record${record.id}"
                                      title="Show goal">
                            <span style="color: #004499; font-weight: bold">
                            xx ${record.goal?.summary}</span>
                        </g:remoteLink>

                    </g:if>
                </g:if>
                <g:if test="${'JP'.contains(entityCode)}">
                    <g:if test="${record.goal}">
                        <g:remoteLink controller="generics" action="showSummary" id="${record.goal.id}"
                                      params="[entityCode: 'G']"
                                      update="below${entityCode}Record${record.id}"
                                      title="Show goal">
                            <br/><i>G-${record.goal?.id}</i>
                            <span style="color: #004499; font-weight: bold">${record.goal?.summary}</span>

                        </g:remoteLink>

                    </g:if>
                </g:if>

                <g:if test="${'C'.contains(entityCode)}">

                    <g:if test="${record.book}">
                        <br/>
                        <g:remoteLink controller="generics" action="showSummary" id="${record.book.id}"
                                      params="[entityCode: 'R']"
                                      update="below${entityCode}Record${record.id}"
                                      title="Show book">
                            ~ R-${record.book.id} ${record.book.title}.
                        </g:remoteLink>
                    </g:if>
                    <g:if test="${record.pages}">
                        <u>page ${record.pages}</u>
                    </g:if>
                </g:if>


            &nbsp;
                <g:if test="${'JWC'.contains(entityCode)}">

                    <g:if test="${record.blogCode && record.publishedNodeId}">
                        <div style="display: inline; padding: 2px; background: #004499; color: #ffffff;" class=""
                             title="ID ${record.publishedNodeId ?: '?'} ${record.publishedOn ? ' on ' + record.publishedOn?.format('dd.MM.yyyy HH:mm') : ''}">
                            ${record.blogCode}
                        </div>

                    </g:if>

                    <g:if test="${record.blogCode && !record.publishedNodeId}">
                        <div style="display: inline; padding: 2px; background: #ff0000; color: #ffffff;" class=""
                             title="ID ${record.publishedNodeId ?: '?'} ${record.publishedOn ? ' on ' + record.publishedOn?.format('dd.MM.yyyy HH:mm') : ''}">
                            ${record.blogCode}
                        </div>

                    </g:if>



                %{--<g:if test="${record.publishedNodeId}">--}%
                %{--<br/>--}%
                %{----}%
                %{--<br/>--}%
                %{--</g:if>--}%

                </g:if>

            </td>
            
            
            
            
              <g:if test="${entityCode == 'R' && record?.type?.code == 'ebk'}">

<td rowspan="2">
            
             <g:if test="${(new File(OperationController.getPath('covers.sandbox.path') + '/' +
             record?.type?.code + '/' + params.id + '.jpg')?.exists() || new File(OperationController.getPath('covers.repository.path') + '/' + record?.type?.code + '/' + params.id + '.jpg')?.exists())}">
               
                <a href="${createLink(controller: 'book', action: 'viewImage', id: record.id)}"
                   target="_blank">
                    <img class="Photo" style="width: 100; height: 130; display:inline"
                         src="${createLink(controller: 'book', action: 'viewImage', id: record.id, params: [date: new Date()])}"/>
                </a>
             </g:if>
          
          </td>
            </g:if> 
            

            
            
            
        </tr>
    </g:if>
</g:if>


<div id="below${entityCode}Record${record.id}">
<g:if test="${expandedView == true}">
    <g:render template="/gTemplates/recordDetails" model="[record: record]"/>
</g:if>

</div>


</div>
</div>

</g:if>

<script type="text/javascript">
    // bug of reformating if pomegranate is replaced by contextPath
    //    jQuery('.schedule').editable('pomegranate/task/schedule', { id   : 'id', name : 'newvalue'});

</script>
