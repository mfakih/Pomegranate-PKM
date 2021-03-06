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

     style="background: #f2f2f2;  box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.2); padding: 0px;  margin: 3px; border-radius: 0px; margin-top: 15px;">

<table class="fixed-layout recordLine">
<tbody>

<tr style="background: #f5f5f5 !important">

<td class="record-id" style="width: 15px" onmouseover="jQuery('.temp44').addClass('actionsButtons'); jQuery('#actionsButtons${record.id}').removeClass('actionsButtons')">

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
        %{--<sup>${record.id}</sup>--}%
        <div style="color: #001b1b; font-weight: bold; font-size: 10px; margin-top: 4px;">
            ${record.class.declaredFields.name.contains('type') ? record?.type?.code : ''}
        </div>
    </g:remoteLink>
    %{--<sup style="color: #6E6E6E; font-size: 10px; padding-top: 3px;">${record.id}</sup>--}%

%{--</g:else>--}%



%{--</g:remoteLink>--}%

</td>





   	 <g:if test="${new File(OperationController.getPath('module.sandbox.' + entityCode + '.path') + '/' + record.id + 'j.jpg')?.exists() || new File(OperationController.getPath('module.sandbox.' + entityCode + '.path') + '/' + record.id + 'n.jpg')?.exists()}">
        
<td style="width: 65px;">		 
            
			<ul class="product-gallery">
 
<li class="gallery-img" id="recordImage${record.id}">
                    <img  class="Photo" style="width: 60; height: 80; display:inline"
                         src="${createLink(controller: 'generics', action: 'viewRecordImage', id: record.id, params: [entityCode: entityCode, date: new Date()])}"/>
              
			
</li> 
</ul>
<script type="text/javascript">
jQuery('#recordImage${record.id}').Am2_SimpleSlider();
</script>			
				
				</td>
				
				
				
             </g:if>
			 
			 
			 <g:if test="${entityCode == 'R'}">

            <g:if test="${(new File(OperationController.getPath('covers.sandbox.path') + '/' +
                    record?.type?.code + '/' + record.id + '.jpg')?.exists() || new File(OperationController.getPath('covers.repository.path') + '/' + record?.type?.code + '/' + record.id + '.jpg')?.exists())}">
                <td style="width: 55px;">


                    <ul class="product-gallery">

                        <li class="gallery-img" id="recordImageCover${record.id}">
                            <img  class="Photo" style="width: 50; height: 70; display:inline"
                                  src="${createLink(controller: 'book', action: 'viewImage', id: record.id, params: [date: new Date()])}"/>


                        </li>
                    </ul>
                    <script type="text/javascript">
                        jQuery('#recordImageCover${record.id}').Am2_SimpleSlider();
                    </script>



                </td>
            </g:if>


    </g:if>

    <g:if test="${entityCode == 'E'}">

            <g:if test="${(new File(OperationController.getPath('covers.sandbox.path') + '/exr/' +
                     record?.id + '.jpg')?.exists() || new File(OperationController.getPath('covers.repository.path') + '/exr/' + record?.id + '.jpg')?.exists())}">
                <td>


                    <ul class="product-gallery">

                        <li class="gallery-img" id="recordImageCover${record.id}">
                            <img  class="Photo" style="width: 50; height: 70; display:inline"
                                  src="${createLink(controller: 'book', action: 'viewExcerptImage', id: record.id, params: [date: new Date()])}"/>


                        </li>
                    </ul>
                    <script type="text/javascript">
                        jQuery('#recordImageCover${record.id}').Am2_SimpleSlider();
                    </script>

                </td>
            </g:if>

    </g:if>



    <td class="record-summary text${record.class.declaredFields.name.contains('language') ? record.language : ''} ${record.class.declaredFields.name.contains('status') && record.status ? 'status-' + record?.status?.code: ''}"
    style="font-family: Arial; font-size: 13px; color: #105CB6; padding-right: 10px; padding-left: 10px; padding-bottom: 4px; padding-top: 4px;">


%{--<g:remoteLink controller="generics" action="showDetails"--}%
              %{--params="${[id: record.id, entityCode: entityCode]}"--}%
              %{--update="below${entityCode}Record${record.id}"--}%
              %{--title="Details">--}%
%{--<g:render template="/gTemplates/summaryField" model="[record: record, entityCode: entityCode]"/>--}%
%{----}%
    %{--</g:remoteLink>--}%


            <g:render template="/gTemplates/summaryField" model="[record: record, entityCode: entityCode]"/>




    </td>




    <g:if test="${record.class.declaredFields.name.contains('status') && record.status}">
        <td class="actionTd">

        <g:set value="status" var="field"></g:set>

        <a href="#" id="${field}${record.id}" class="${field}" data-type="select" data-value="${record[field]?.id}"
           data-name="${field}-${entityCode}"
           style="${record.status ? record.status?.style : ''}; border: 0.5px solid #808080; border-radius: 3px; font-size: 11px; font-style: italic; padding-left: 2px; padding-right: 2px;"
           data-source="/pkm/operation/getQuickEditValues?entity=${entityCode}&field=${field}&date=${new Date().format('hhmmssDDMMyyyy')}"
           data-pk="${record.id}" data-url="/pkm/operation/quickSave2" data-title="Edit ${field}">
            ${record[field] ? record[field]?.code : ''}
        </a>
        <script>
            $('#${field}${record.id}').editable();
        </script>

        </td>

    </g:if>



    %{--<g:if test="${record.class.declaredFields.name.contains('type') && entityCode.length() == 1}">--}%
        %{--<g:set value="type" var="field"></g:set>--}%
        %{--<span style="min-width: 60px;">--}%
            %{--<a href="#" id="${field}${record.id}" class="${field}" data-type="select" data-value="${record[field]?.id}"--}%
               %{--style="${record.type ? record.type?.style : ''};font-size: 11px; font-weight: bold;margin-left: 5px;"--}%
               %{--data-name="${field}-${entityCode}"--}%
               %{--data-source="/pkm/operation/getQuickEditValues?entity=${entityCode}&field=${field}&date=${new Date().format('hhmmssDDMMyyyy')}"--}%
               %{--data-pk="${record.id}" data-url="/pkm/operation/quickSave2" data-title="Edit ${field}">--}%
                %{--<br/>  ${record[field]?.code ?: ''}--}%
            %{--</a>--}%
        %{--</span>--}%
        %{--<script>--}%
            %{--$('#${field}${record.id}').editable();--}%
        %{--</script>--}%
    %{--</g:if>--}%



%{--<span style="float: right">--}%
%{--<a class="fg-button fg-button-icon-solo ui-widget ui-state-default ui-corner-all"--}%
%{--onclick="jQuery('#appendRow${entityCode}-${record.id}').removeClass('navHidden'); jQuery('#appendTextFor${entityCode}${record.id}').select(); jQuery('#appendTextFor${entityCode}${record.id}').focus();">--}%
%{--<span class="ui-icon ui-icon-arrowreturn-1-e"></span>--}%
%{--</a>--}%


%{--<g:remoteLink controller="page" action="panel"--}%
%{--params="${[id: record.id, entityCode: entityCode]}"--}%
%{--update="3rdPanel"--}%
%{--before="jQuery('#accordionEast').accordion({ active: 0});"--}%
%{--class=" fg-button fg-button-icon-solo ui-widget ui-state-default ui-corner-all"--}%
%{--title="Go to page">--}%
%{--<span class="ui-icon ui-icon-extlink"></span>--}%

%{--</g:remoteLink>--}%




<td class="actionTd showhim"
 style="${justUpdated ? 'background: YellowGreen !important' : ''}"
    >
    <g:remoteLink controller="generics" action="getAddForm" id="${record.id}"
                  params="[entityController: record.class.name,
                          updateRegion:  entityCode + 'Record' + record.id,
                          finalRegion: entityCode + 'Record' + record.id]"
                  class="fg-button fg-button-icon-solo ui-widget ui-state-default ui-corner-all"
                  update="${entityCode}Record${record.id}"
                  title="Edit">
        <span class="ui-icon ui-icon-pencil"></span>
    </g:remoteLink>

%{--<g:remoteLink controller="generics" action="getAddForm"--}%
              %{--params="[entityController: i.controller, updateRegion: 'centralArea']"--}%
              %{--update="centralArea">--}%
    %{--+ note--}%
    %{--</g:remoteLink>--}%

</td>


<td class="record-selection">

        %{--onchange="jQuery('#logRegion').load('/pkm/generics/select/${entityCode}${record.id}')"--}%
        <g:checkBox name="select-${record.id}-${entityCode}" title="Select record"
                    value="${session[entityCode + record.id] == 1}"

                    onclick="jQuery('#logRegion').load('/pkm/generics/select/${entityCode}${record.id}')"/>
        <!--a style="width: 10px; color: #000000"
           onclick="jQuery('#below${entityCode}Record${record.id}').html('')">&chi;</a-->

    </td>


    <td class="actionTd" onmouseover="jQuery('.temp44').addClass('actionsButtons'); jQuery('#actionsButtons${record.id}').removeClass('actionsButtons')">

        <g:if test="${record.class.declaredFields.name.contains('bookmarked')}">
            <g:if test="${!record.bookmarked}">
                <a name="bookmark${record.id}${entityCode}" title="Toggle bookmark"
                   value="${record.bookmarked}"
                   onclick="jQuery('#${entityCode}Record${record.id}').load('/pkm/generics/quickBookmark/${entityCode}-${record.id}')">
                    <span class="icon-star-gm"></span>
                </a>


            </g:if>

            <g:if test="${record.bookmarked}">
                <a name="bookmark${record.id}${entityCode}" title="Toggle bookmark"
                   value="${record.bookmarked}"
                   onclick="jQuery('#${entityCode}Record${record.id}').load('/pkm/generics/quickBookmark/${entityCode}-${record.id}')">
                    <span class="icon-starred-gm"></span>
                </a>

            </g:if>
        </g:if>


    </td>


    <td  style="width: 8px; margin-top: 4px; padding: 4px; ; " onmouseover="jQuery('.temp44').addClass('actionsButtons'); jQuery('#actionsButtons${record.id}').removeClass('actionsButtons')">
        <div class="idCell" style="font-size: 10px; -moz-transform:rotate(-90deg); -moz-transform-origin: middle right; -webkit-transform: rotate(-90deg); -webkit-transform-origin: middle right; -o-transform: rotate(-90deg); -o-transform-origin:  middle right; ;">


            <g:remoteLink controller="page" action="panel"
              params="${[id: record.id, entityCode: entityCode]}"
              update="3rdPanel"
              before="jQuery('#accordionEast').accordion({ active: 0});"
              title="Go to page">
    ${record.id}

    </g:remoteLink>
	
    
        </div>
    </td>



</tr>

 <tr>
     <td class="actionTd " colspan="10" style="">



         <div id="actionsButtons${record.id}" class="temp44 actionsButtons actionsButtonsStyle" style="background: white; font-size: 9px !important;">

             <g:if test="${record.class.declaredFields.name.contains('writing') && entityCode == 'N'}">
                 <g:set value="writing" var="field"></g:set>

                 <a href="#" id="${field}${record.id}" class="${field}" data-type="select" data-value="${record[field]?.id}"
                    data-name="${field}-${entityCode}"
                    style="border-bottom: 0.5px solid #808080; font-size: 11px; text-decoration: italic;  float: right; padding-right: 4px;"
                    data-source="/pkm/operation/getQuickEditValues?entity=${entityCode}&field=${field}&date=${new Date().format('hhmmssDDMMyyyy')}"
                    data-pk="${record.id}" data-url="/pkm/operation/quickSave2" data-title="Edit ${field}">
                     ${record[field] ? record[field]?.summary : '?wrt'}
                 </a>
                 <script>
                     %{--$('#${field}${record.id}').editable();--}%
                 </script>

             </g:if>







             <g:remoteLink controller="generics" action="showTags"
                       params="${[id: record.id, entityCode: entityCode]}"
                       update="below${entityCode}Record${record.id}"
                       title="Details">
             Tag...  &nbsp;&nbsp;
         </g:remoteLink>

             <g:remoteLink controller="generics" action="showRelate"
                       params="${[id: record.id, entityCode: entityCode]}"
                       update="below${entityCode}Record${record.id}"
                       title="Details">
             Relates...  &nbsp;&nbsp;
         </g:remoteLink>

   <g:remoteLink controller="generics" action="showChildren"
                       params="${[id: record.id, entityCode: entityCode]}"
                       update="below${entityCode}Record${record.id}"
                       title="Details">
             Children...  &nbsp;&nbsp;
         </g:remoteLink>


         <g:if test="${record.class.declaredFields.name.contains('priority')}">
                 <a name="bookmark${record.id}${entityCode}" title="priority++"
                    value="${record.priority}"
                    onclick="jQuery('#${entityCode}Record${record.id}').load('/pkm/generics/increasePriority/${entityCode}${record.id}')">
                     Priority++ &nbsp;
                 </a>
             </g:if>

             <g:if test="${record.class.declaredFields.name.contains('endDate')}">
                 <a name="bookmark${record.id}${entityCode}" title="endDate today"
                    value="${record.endDate}"
                    onclick="jQuery('#${entityCode}Record${record.id}').load('/pkm/generics/setEndDateToday/${entityCode}${record.id}')">
                     Today! &nbsp;
                 </a>
             </g:if>
             <g:if test="${record.class.declaredFields.name.contains('percentCompleted')}">
                 <a name="bookmark${record.id}${entityCode}" title="percent++"
                    value="${record.percentCompleted}"
                    onclick="jQuery('#${entityCode}Record${record.id}').load('/pkm/generics/increasePercentCompleted/${entityCode}${record.id}')">
                     Percent++ &nbsp;
                 </a>
             </g:if>

             <g:if test="${record.class.declaredFields.name.contains('isPrivate')}">

                 <a name="bookmark${record.id}${entityCode}" title="Toggle privacy"
                    value="${record.isPrivate}"
                    onclick="jQuery('#${entityCode}Record${record.id}').load('/pkm/generics/togglePrivacy/${entityCode}-${record.id}')">
                 Private! &nbsp;
                 </a>

             </g:if>



         %{--update="commentArea${entityCode}${record.id}"--}%
             <g:remoteLink controller="generics" action="showComments" style="display: inline;"
                           params="${[id: record.id, entityCode: entityCode]}"
                           update="3rdPanel"
                           before="jQuery('#accordionEast').accordion({ active: 0});"
                           title="show index cards">

                 <g:if test="${app.IndexCard.countByEntityCodeAndRecordId(entityCode, record.id) > 0 || (entityCode == 'W' ? app.IndexCard.countByWriting(Writing.get(record.id)) > 0 : false) || (entityCode == 'R' ? app.IndexCard.countByBook(Book.get(record.id)) > 0 : false)}">

                 %{--<span class="ui-icon ui-icon-comment"></span>--}%
                     (<span>

                         <g:if test="${entityCode == 'W'}">
                             ${app.IndexCard.countByWriting(Writing.get(record.id)) + app.IndexCard.countByEntityCodeAndRecordId(entityCode, record.id)}
                         </g:if>
                         <g:elseif test="${entityCode == 'R'}">
                             ${app.IndexCard.countByBook(Book.get(record.id)) + app.IndexCard.countByEntityCodeAndRecordId(entityCode, record.id)}
                         </g:elseif>
                         <g:else>
                             ${app.IndexCard.countByEntityCodeAndRecordId(entityCode, record.id)}
                         </g:else>

                     </span>
                     comments)
                 </g:if>
                 <g:else>
                 %{--<span class="ui-icon ui-icon-comment"></span>--}%



                 </g:else>
                 <g:remoteLink controller="generics" action="showComment"
                               params="${[id: record.id, entityCode: entityCode]}"
                               update="below${entityCode}Record${record.id}"
                               title="Details">
                     Comment...
                 </g:remoteLink>

             </g:remoteLink>

<g:if test="${'CTGRE'.contains(entityCode)}">

         <g:remoteLink controller="generics" action="showJP"
                       params="${[id: record.id, entityCode: entityCode]}"
                       update="below${entityCode}Record${record.id}"
                       title="Details">
             +JP...
         </g:remoteLink>
    </g:if>
       <g:remoteLink controller="generics" action="showAppend"
                       params="${[id: record.id, entityCode: entityCode]}"
                       update="below${entityCode}Record${record.id}"
                       title="Details">
             Append...    &nbsp;&nbsp;
         </g:remoteLink>


         <g:if test="${'TPGRE'.contains(entityCode)}">

                 <g:remoteLink controller="generics" action="markCompleted" id="${record.id}"
                               params="[entityCode: entityCode]"
                               update="${entityCode}Record${record.id}"
                               title="Mark completed">
                     Done!   &nbsp;&nbsp;
                 </g:remoteLink>
         </g:if>

  <g:if test="${'RWN'.contains(entityCode)}">

                 <g:remoteLink controller="generics" action="setArabic" id="${record.id}"
                               params="[entityCode: entityCode]"
                               update="${entityCode}Record${record.id}"
                               title="Mark arabic">
                     Ar!   &nbsp;&nbsp;
                 </g:remoteLink>
         </g:if>


         </div>
     %{--<span id="priorityRegion${entityCode}${record.id}">${record.priority}</span>--}%


     </td>

 </tr>


<g:if test="${'CTGR'.contains(entityCode) && record.percentCompleted}">
<tr>
<td colspan="10" style="padding: 0px; margin: 0px;">
<pkm:progressBar percent="${record.percentCompleted}"/>
</td>
</tr>
</g:if>


</tbody>
</table>


<g:if test="${session['showLine1Only'] == 'off'}">
   <g:render template="/gTemplates/2ndLine" model="[record: record, entityCode: entityCode]"/>
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

    jQuery('#summary').val('')
    jQuery('#description').val('')
   //jQuery('#link').val('')
    //jQuery('#approximateDate').clear()
//    jQuery('#chosenTags').val('').trigger('chosen:updated');
//    jQuery('#chosenTags').val('').trigger('liszt:updated');
</script>
