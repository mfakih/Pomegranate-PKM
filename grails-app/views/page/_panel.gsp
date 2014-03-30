%{--
  - Copyright (c) 2014. Mohamad F. Fakih (mail@mfakih.org)
  -
  - This program is free software: you can redistribute it and/or modify
  - it under the terms of the GNU General Public License as published by
  - the Free Software Foundation, either version 3 of the License, or
  - (at your option) any later version.
  -
  - This program is distributed in the hope that it will be useful,
  - but WITHOUT ANY WARRANTY; without even the implied warranty of
  - MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  - GNU General Public License for more details.
  -
  - You should have received a copy of the GNU General Public License
  - along with this program.  If not, see <http://www.gnu.org/licenses/>
  --}%

<%@ page import="cmn.DataChangeAudit; ker.OperationController; app.Indicator; mcs.Goal; mcs.Task; mcs.Journal; mcs.Writing; app.IndexCard; mcs.Excerpt; mcs.Book; mcs.Course;" %>

    %{--<r:require modules="application"/>--}%
    <r:require module="fileuploader"/>
    %{--<r:require modules="jquery"/>--}%
    %{--<r:require modules="jquery-ui"/>--}%
%{----}%

    <r:layoutResources/>



<g:if test="${record.entityCode().length() == 1}">
    <div style="display: inline; text-align: right;">
        <uploader:uploader id="uploadAsNoteWithAttachment${record.id}"
                           url="${[controller: 'import', action: 'upload']}"
                           params="${[recordId: record.id, entityCode: record.entityCode()]}">
                <uploader:onComplete>
                    jQuery('#subUploadInPanel').load('generics/showSummary/' + responseJSON.id + '?entityCode=' +  responseJSON.entityCode)
                </uploader:onComplete>
            Attach...
        </uploader:uploader>

        <br/>
        <uploader:uploader id="addToRecordFolder${record.id}"
                           url="${[controller: 'import', action: 'addToRecordFolder']}"
                           params="${[recordId: record.id, entityCode: record.entityCode()]}">
            Add to record folder
        </uploader:uploader>
    </div>
        <div id="subUploadInPanel"></div>
</g:if>


<g:if test="${record.entityCode() == 'R'}">
<g:if test="${(new File(OperationController.getPath('covers.sandbox.path') + '/' +
        record?.type?.code + '/' + record.id + '.jpg')?.exists() || new File(OperationController.getPath('covers.repository.path') + '/' + record?.type?.code + '/' + record.id + '.jpg')?.exists())}">

    <a href="${createLink(controller: 'book', action: 'viewImage', id: record.id)}"
       target="_blank">
        <img class="Photo" style="width: 80px; height:120px; display:inline"
             src="${createLink(controller: 'book', action: 'viewImage', id: record.id, params: [date: new Date()])}"/>
    </a>
</g:if>


    <h2>Resource</h2>
    ${record.title}
</g:if>

<g:if test="${record.entityCode() == 'G'}">
    <h2>Goal</h2>
    ${record.summary}

</g:if>

<g:if test="${record.entityCode() == 'W'}">
    <h2>Writing</h2>
    ${record.summary}
</g:if>

<g:render template="/gTemplates/filesListing" model="[record: record, entityCode: record.entityCode()]"/>
        %{--<g:if test="${record.class.declaredFields.name.contains('shortDescription')}">--}%
            %{--<span style="font-size: 12px; font-style: italic; color: #4A5C69">--}%
                %{--<b>Summary:</b> ${record?.shortDescription?.replaceAll('\n', '<br/>')}--}%
            %{--</span>--}%
        %{--</g:if>--}%



        <g:if test="${record.class.declaredFields.name.contains('description')}">

            <div style="padding: 3px; font-size: 13px; font-family: georgia; margin: 5px; line-height: 20px; text-align: justify">
                <span id="descriptionBloc${record.id}">
               Description:     ${record.description?.replaceAll('\n', '<br/>')?.decodeHTML()?.replaceAll('\n', '<br/>')?.replace('Product Description', '')}
                    %{--${?.encodeAsHTML()?.replaceAll('\n', '<br/>')}--}%
                </span>

                %{--${WikiParser.renderXHTML(record.description)?.replaceAll('\n', '<br/>')?.decodeHTML()}--}%

            </div>
            <g:if test="${record.entityCode() == 'W'}">

                <g:remoteLink url="[controller: 'operation', action: 'convertAsciiDocToHtml', id: record.id]"
                              update="descriptionBloc${record.id}"
                              class="actionLink"
                              title="Convert to HTML">
                    Convert to HTML (inline)
                </g:remoteLink>
                </g:if>

                <g:if test="${record.entityCode() == 'C'}">


                    <g:link url="[controller: 'export', action: 'generateCourseWritingsAsHtml', id: record.id]"
                              class="actionLink"
                    target="_blank"
                              title="Convert to HTML">
                    Combine writings in HTML format (new tab)
                </g:link>
                
              <br/>
                    <g:link url="[controller: 'export', action: 'generateCourseWritingsAsIs', id: record.id]"
                              class="actionLink"
                    target="_blank"
                              title="Convert to HTML">
                    Combine writings as is (new tab)
                </g:link>
                
                
                
<br/>
<br/>
  <g:link url="[controller: 'export', action: 'generateCoursePresentation', id: record.id]"
                              class="actionLink"
                    target="_blank"
                              title="Convert to HTML">
                    Generate presentation (new tab)
                </g:link>


            </g:if>
        </g:if>


    %{--direction: ${record?.source?.language == 'ar' ? 'rtl' : 'ltr'}--}%
    %{--todo--}%







    %{--direction: ${record?.source?.language == 'ar' ? 'rtl' : 'ltr'}; text-align: ${record?.source?.language == 'ar' ? 'right' : 'left'}--}%
    %{--todo--}%

    %{--</div>--}%





%{--<g:each in="${app.IndexCard.findAllByEntityCodeAndRecordId(entityCode, record.id)}" var="c">--}%
    %{--<g:render template="/gTemplates/box" model="[record: c]"/>--}%
%{--</g:each>--}%

%{--<g:if test="${'R'.contains(record.entityCode())}">--}%
    %{--<g:each in="${app.IndexCard.findAllByBook(record)}" var="c">--}%
        %{--<g:render template="/gTemplates/box" model="[record: c]"/>--}%
    %{--</g:each>--}%
%{--</g:if>--}%
%{--<g:if test="${'W'.contains(record.entityCode())}">--}%
    %{--<g:each in="${app.IndexCard.findAllByWriting(record)}" var="c">--}%
        %{--<g:render template="/gTemplates/box" model="[record: c]"/>--}%
    %{--</g:each>--}%
%{--</g:if>--}%

</div>


<g:if test="${record.entityCode() == 'todoR'}">
    <div id="type-4" style="">

        <g:if test="${'R'.contains(record.entityCode())}">
        %{--<h4>Notes</h4>--}%

            <h4>Excerpts</h4>
            <g:each in="${Excerpt.findAllByBook(record)}" var="r">

                <g:render template="/gTemplates/recordSummary" model="[record: r, expandedView: false]"/>
            </g:each>
        %{--<g:each in="${Planner.findAllByBook(record)}" var="r">--}%
        %{----}%
        %{--<g:render template="/gTemplates/recordSummary" model="[record: r]"/>--}%
        %{--</g:each>--}%

        </g:if>

    </div>
      </g:if>




<table style="border: 0px solid; vertical-align: top; border-collapse: collapse; width: 99%" border="0">
    <tr>
        <td style="vertical-align: top; width: 99%">

            %{--<g:if test="${'B'.contains(record.entityCode())}">--}%
            %{--<b>Description</b>--}%
            %{--<br/>--}%
            %{----}%

            <div style="padding: 3px; font-size: 13px; font-family: tahoma; margin: 5px; line-height: 20px">



            <g:if test="${record.notes}">
                <br/>
                Notes: <i style="color: #1d806f">${record.notes?.replaceAll('\n', '<br/>')}</i>
                <br/><hr/><br/>
            </g:if>

            %{--</g:if>--}%
            %{--<br/>--}%


                <g:if test="${'R'.contains(record.entityCode())}">
                    <div style="font-family: tahoma; text-align: justify; line-height: 20px; font-size: 14px; margin: 5px;">
                        <g:if test="${record.highlights}">
                            <i style="color: #48802C">
                                ${record.highlights?.replaceAll('\n', '<br/>')}
                            </i>
                            <br/>
                        </g:if>
                        <g:if test="${record.comments}">
                            <br/>
                            <i style="color: #1d806f">${record.comments?.replaceAll('\n', '<br/>')}</i>
                        %{--<br/><hr/><br/>--}%
                            <br/><hr/><br/>
                        </g:if>
                        <g:if test="${record.fullText}">
                            <div class="${record.language == 'ar' ? 'arabicText' : ''}">
                       Full text:         ${record.fullText?.replaceAll('\n', '<br/>')}
                            </div>
                        </g:if>
                    </div>
                </g:if>
            </div>

        </td>

    </tr>
</table>


    <div id="type-2" style="">

        <g:if test="${record.entityCode() == 'C'}">
         <h4>Writings</h4>
            <g:each in="${mcs.Writing.findAllByCourse(record, [sort: 'orderInCourse', order: 'asc'])}"
                    var="c">
                <g:render template="/gTemplates/recordSummary" model="[record: c, expandedView: false]"/>
                <g:each in="${app.IndexCard.findAllByWriting(c, [sort: 'orderInWriting', order: 'asc'])}"
                        var="i">
                    <div style="margin-left: 20px">
                    <g:render template="/gTemplates/recordSummary" model="[record: i]"/>
                    </div>
                </g:each>

            <%--  <g:each in="${app.IndexCard.findAllByWriting(c, [sort: 'orderInWriting', order: 'asc'])}"
                       var="i">
                   <g:render template="/gTemplates/box" model="[record: i]"/>
               </g:each>
                --%>
            </g:each>
        </g:if>
</div>

%{--<div id="type-5" style="">--}%
        %{--<span id="commentArea${record.entityCode()}${record.id}" style="display: inline;  margin-left: 10px;">--}%


        %{--</span>--}%

    %{--</div>--}%



<h4>Notes</h4>

<div id="panelComments${entityCode}Record${record.id}">
<g:render template="/indexCard/add" model="[recordId: record.id, recordEntityCode: entityCode]"/>


<div id="type-7" style="">

    %{--todo--}%
%{--<g:each in="${DataChangeAudit.findAllByEntityIdAndRecordId(144,record.id, [sort: 'dateCreated', order: 'desc'])}" var="c">--}%
%{--<br/>--}%
%{--<br/>--}%
   %{--${c.userName}: ${c.datePerformed}     ${c.operationType}<br/>--}%











%{--<g:each in="${c.operationDetails.split(';;')}" var="f">--}%
    %{--<g:if test="${c.operationType == 'Update'}">--}%
    %{--<b>${f.split(/\|\|/)[0]}:</b>--}%
    %{--${f.split(/\|\|/)[1]} ->--}%
    %{--${f.split(/\|\|/)[2]}:--}%
%{--<br/>    </g:if>--}%
     %{--<g:else>--}%
         %{--${f}<br/>--}%
     %{--</g:else>--}%
%{--</g:each>--}%

%{--</g:each>--}%



</div>




<div id="cardBoxes">

  %{----}%

    %{--<g:if test="${record.entityCode() == 'W'}">--}%
        %{--<g:each in="${app.IndexCard.findAllByWriting(Writing.get(record.id), [sort: 'orderInWriting', order: 'asc'])}"--}%
                %{--var="c">--}%
            %{--<g:render template="/gTemplates/box" model="[record: c]"/>--}%
        %{--</g:each>--}%
    %{--</g:if>--}%


</div>




<div id="notificationArea"></div>

<r:layoutResources/>
