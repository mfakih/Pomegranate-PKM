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

<g:render template="/gTemplates/summaryField" model="[record: record, entityCode: entityCode]"/>


</td>

%{-- end of record summary --}%



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
