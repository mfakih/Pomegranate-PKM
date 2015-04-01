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

<%@ page import="org.ocpsoft.prettytime.PrettyTime; cmn.DataChangeAudit; ker.OperationController; app.Indicator; mcs.Goal; mcs.Task; mcs.Journal; mcs.Writing; app.IndexCard; mcs.Excerpt; mcs.Book; mcs.Course;" %>

    %{--<r:require modules="application"/>--}%
    <r:require module="fileuploader"/>
    %{--<r:require modules="jquery"/>--}%
    %{--<r:require modules="jquery-ui"/>--}%
%{----}%

    <r:layoutResources/>


<g:set var="entityCode"
       value="${record.metaClass.respondsTo(record, 'entityCode') ? record.entityCode() : record.class?.name?.split(/\./).last()}"/>


<g:remoteLink controller="page" action="panel"
              params="${[id: record.id, entityCode: entityCode]}"
              update="3rdPanel"
              title="Click to refresh">


%{--<sup>${record.id}</sup>--}%

    <div style="padding: 1px; font-size: 15px; font-family: georgia; margin: 3px; line-height: 20px; text-align: justify">
        <span class="${entityCode}-bkg ID-bkg ${record.class.declaredFields.name.contains('deletedOn') && record.deletedOn ? 'deleted' : ''}"
              style="padding: 3px; margin-right: 3px; color: gray;">
            <b style="color: white;">${entityCode}</b>
            ${record.id}
        </span>
        <g:if test="${record.class.declaredFields.name.contains('summary')}"><u>${record.summary}</u></g:if>
        <g:if test="${record.class.declaredFields.name.contains('title')}"><u>${record.title}</u></g:if>
    </div>

</g:remoteLink>



%{--<h4>Files</h4>--}%



<g:render template="/gTemplates/filesListing" model="[record: record, entityCode: record.entityCode()]"/>


<pkm:listPictures fileClass="snsFile"
                  folder="${OperationController.getPath('module.sandbox.' + record.entityCode() + '.path')}/${record.id}"
                  initial=""/>

<pkm:listPictures fileClass="snsFile"
                  folder="${OperationController.getPath('module.repository.' + record.entityCode() + '.path')}/${record.id}"
                  initial="${record.id}"/>

<pkm:listPictures fileClass="snsFile"
                  folder="${OperationController.getPath('module.sandbox.' + record.entityCode() + '.path')}"
                  initial="${record.id}"/>

<pkm:listPictures fileClass="snsFile"
                  folder="${OperationController.getPath('module.repository.' + record.entityCode() + '.path')}"
                  initial="${record.id}"/>

<pkm:listPictures fileClass="snsFile"
                  folder="${OperationController.getPath('jrn.sns.path') + '/' + record.entityCode() + '/' + record.id}"
                  initial=""/>
    <pkm:listAudios fileClass="rcdFile"
                  folder="${OperationController.getPath('jrn.rcd.path') + '/' + record.entityCode() + '/' + record.id}"
                  initial=""/>
    <pkm:listVideos fileClass="videoFile"
                  folder="${OperationController.getPath('jrn.vjr.path') + '/' + record.entityCode() + '/' + record.id}"
                  initial=""/>





<g:if test="${record.entityCode() == 'R'}">
<g:if test="${(new File(OperationController.getPath('covers.sandbox.path') + '/' +
        record?.type?.code + '/' + record.id + '.jpg')?.exists() || new File(OperationController.getPath('covers.repository.path') + '/' + record?.type?.code + '/' + record.id + '.jpg')?.exists())}">

    <a href="${createLink(controller: 'book', action: 'viewImage', id: record.id)}"
       target="_blank">
        <img class="Photo" style="width: 80px; height:120px; display:inline"
             src="${createLink(controller: 'book', action: 'viewImage', id: record.id, params: [date: new Date()])}"/>
    </a>
</g:if>


      
</g:if>





        %{--<g:if test="${record.class.declaredFields.name.contains('shortDescription')}">--}%
            %{--<span style="font-size: 12px; font-style: normal; color: #4A5C69">--}%
                %{--<b>Summary:</b> ${record?.shortDescription?.replaceAll('\n', '<br/>')}--}%
            %{--</span>--}%
        %{--</g:if>--}%



        <g:if test="${record.class.declaredFields.name.contains('description')}">
  
            <div style="padding: 3px; font-size: 13px; font-family: tahoma; margin: 5px; line-height: 20px; text-align: justify" class="${record.class.declaredFields.name.contains('language') ? 'text' + record.language : ''}">
                <span id="descriptionBloc${record.id}">
               
                   ${record.description?.replaceAll('\n', '<br/>')?.decodeHTML()?.replaceAll('\n', '<br/>')?.replace('Product Description', '')}
                  
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
                    Combine writings (HTML)
                </g:link>
                
              <br/>
              <br/>
              <br/>
                    <g:link url="[controller: 'export', action: 'generateCourseWritingsAsIs', id: record.id]"
                              class="actionLink"
                    target="_blank"
                              title="Convert to HTML">
                    Combine writings as is
                </g:link>
                
                
                %{----}%
%{--<br/>--}%
%{--<br/>--}%
  %{--<g:link url="[controller: 'export', action: 'generateCoursePresentation', id: record.id]"--}%
                              %{--class="actionLink"--}%
                    %{--target="_blank"--}%
                              %{--title="Convert to HTML">--}%
                    %{--Generate presentation (new tab)--}%
                %{--</g:link>--}%


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




<g:if test="${'R'.contains(entityCode)}">
%{--<b>${record.title?.encodeAsHTML()?.replaceAll('\n', '<br/>')}</b>--}%
%{--<br/>--}%
    <div style="padding: 3px; font-size: 12px; font-family: tahoma; margin: 5px; line-height: 20px">
        <g:if test="${record.legacyTitle}">
            <span style="font-size: small">
                <br/>    <b>Legacy title:</b>  ${record.legacyTitle}
                <br/>
            </span>
        </g:if>
        <g:if test="${record.author}">
            <b>Author</b>   : ${record.author}
            <br/>
        </g:if>
        <g:if test="${record.isbn}">
            <b>ISBN</b>   : ${record.isbn}
            <br/>
        </g:if>
        <g:if test="${record.nbPages}">
            <b>Nb pages</b>   : ${record.nbPages}
            <br/>
        </g:if>
    %{--Extension: ${record.ext}--}%
    %{--<br/>--}%
        <g:if test="${record.publisher}">
            <b>Publisher</b>: ${record.publisher}
            <br/>
        </g:if>
        <g:if test="${record.publicationDate}">
            <b>Publication date</b>: ${record.publicationDate}
            <br/>
        </g:if>
        <g:if test="${record.edition}">
            <b>Edition</b>: ${record.edition}
            <br/>
        </g:if>

        <g:if test="${record.url}">
            <span style="">
                <b>Link:</b>
                <span id="linkBloc${record.id}"
                ${record.url}
            </span>
        %{--${record.author},${record.title ?: record.legacyTitle} ${record.edition} ed--}%
        %{--(${record.publisher},--}%
        %{--${record.publicationDate})--}%
        </g:if>

    %{--<g:if test="${record?.type?.code == 'link'}">--}%
        <g:if test="${record?.url}">
            <br/>
            <g:remoteLink controller="import" action="scrapHtmlPage" id="${record.id}"
                          update="RRecord${record.id}"
                          class="actionLink"
                          title="Scrap HTML">
                Scrape HTML page
            </g:remoteLink>
            <br/>
            <br/>
        </g:if>

        <g:if test="${record.citationHtml}">
            <span style="">
                <b>Citation:</b>
                <span id="citationBloc${record.id}"
                ${record.citationHtml}
            </span>
        %{--${record.author},${record.title ?: record.legacyTitle} ${record.edition} ed--}%
        %{--(${record.publisher},--}%
        %{--${record.publicationDate})--}%


            <br/>
        </g:if>
        <g:if test="${record.isbn}">
            <g:remoteLink controller="import" action="generateCitation" id="${record.id}"
                          update="citationBloc${record.id}"
                          class="actionLink"
                          title="Update metadata">
                Generate citations
            </g:remoteLink>
            <br/>
            <br/>
        </g:if>


    %{--Amazon tags: ${record.tags}--}%
        <span id="bibTexBloc${record.id}">
            <g:if test="${record.bibEntry}">
                <b>Bib entry:</b>

                <br/>
                ${record.bibEntry}

            </g:if>
        </span>

        <br/>
        <g:if test="${record.isbn}">
            <g:remoteLink controller="operation" action="addBibtex" id="${record.id}"
                          update="bibTexBloc${record.id}"
                          class="actionLink"
                          title="Update metadata">
                Fetch Bib entry
            </g:remoteLink>
        </g:if>
    %{--Amazon tags: ${record.tags}--}%

        <g:if test="${record.withAudiobook}">
            <br/><i>With audiobook</i>
        </g:if>
        <g:if test="${record.isAudiobook}">
            <br/><i>Is audiobook</i>
        </g:if>
        <g:if test="${record.isPaperOnly}">
            <br/><i>Paper format only</i>
        </g:if>

        <g:if test="${record.isRead}">
            <br/><i>Has been read</i>
        </g:if>

        <g:if test="${record.isPublic}">
            <br/><i>To be shared</i>
        </g:if>
    </div>
</g:if>





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
                          <div class="${record.language == 'ar' ? 'arabicText' : ''}">
                            <i style="color: #48802C">
                                ${record.highlights?.replaceAll('\n', '<br/>')}
                            </i>
                            <br/>
                            </div>
                        </g:if>
                        <g:if test="${record.comments}">
                            <br/>
                            <i style="color: #1d806f">${record.comments?.replaceAll('\n', '<br/>')}</i>
                        %{--<br/><hr/><br/>--}%
                            <br/><hr/><br/>
                        </g:if>
                        <g:if test="${record.fullText}">
                            <div class="${record.language == 'ar' ? 'arabicText' : ''}">
                     <br/><hr/>   ${record.fullText?.replaceAll('\n', '<br/>')}
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





<g:if test="${record.class.declaredFields.name.contains('notes')}">
    <div id="notes${entityCode}${record.id}" style="display: inline;">

        <g:if test="${record.notes}">
        %{--<br/>--}%
            <g:render template="/gTemplates/recordNotes" model="[record: record]"/>

        </g:if>
    </div>
</g:if>





<g:if test="${record.entityCode().length() == 1}">
    <div style="display: inline; text-align: right;">
        <table border=0>
            <tr>
                <td>
                    Attach files:
                    <uploader:uploader id="uploadAsNoteWithAttachment${record.id}"
                                       url="${[controller: 'import', action: 'upload']}"
                                       params="${[recordId: record.id, entityCode: record.entityCode()]}">
                        <uploader:onComplete>
                            jQuery('#subUploadInPanel').load('generics/showSummary/' + responseJSON.id + '?entityCode=' +  responseJSON.entityCode)
                        </uploader:onComplete>
                        Attach...
                    </uploader:uploader>
                </td>

                <td>
                    Add to record folder:
                    <uploader:uploader id="addToRecordFolder${record.id}"
                                       url="${[controller: 'import', action: 'addToRecordFolder']}"
                                       params="${[recordId: record.id, entityCode: record.entityCode()]}">
                        Add to record folder
                    </uploader:uploader>


                    <g:if test="${record.entityCode() == 'J'}">

                        Add to <b>sns</b> folder:
                        <uploader:uploader id="addToRecordSnsFolder${record.id}"
                                           url="${[controller: 'import', action: 'addToJRecordFolder']}"
                                           params="${[recordId: record.id, entityCode: record.entityCode(), folderType: 'sns']}">
                            Add to sns folder
                        </uploader:uploader>
                        <br/>

                        Add to <b>rcd</b> folder:
                        <uploader:uploader id="addToRecordRcdFolder${record.id}"
                                           url="${[controller: 'import', action: 'addToJRecordFolder']}"
                                           params="${[recordId: record.id, entityCode: record.entityCode(), folderType: 'rcd']}">
                            Add to rcd folder
                        </uploader:uploader>
                        <br/>

                        Add to <b>vjr</b> folder:
                        <uploader:uploader id="addToRecordVjrFolder${record.id}"
                                           url="${[controller: 'import', action: 'addToJRecordFolder']}"
                                           params="${[recordId: record.id, entityCode: record.entityCode(), folderType: 'vjr']}">
                            Add to vjr folder
                        </uploader:uploader>
                        <br/>



                    </g:if>
                </td>
            </tr>
        </table>




    </div>
    <div id="subUploadInPanel"></div>
</g:if>

<br/>

<div style="font-size: 11px;">
    <br/>
    <br/>
    <br/>
    <br/>
    <b>Updated</b> ${record.lastUpdated?.format(OperationController.getPath('date.format') ? OperationController.getPath('date.format') + ' HH:mm' : 'dd.MM.yyyy HH:mm')} (<prettytime:display
        date="${record.lastUpdated}"/>)
    <br/>
    %{--(<prettytime:display--}%
    %{--date="${record.dateCreated}"/>)--}%
    %{--by ${record.insertedBy}--}%
    %{--editedBy ${record.editedBy}--}%
    <b>Created</b> ${record.dateCreated?.format(OperationController.getPath('date.format') ? OperationController.getPath('date.format') + ' HH:mm' : 'dd.MM.yyyy HH:mm')}
(${new PrettyTime()?.format(record.dateCreated)})
    <br/>
    <b>Version</b> <span style="font-weight: normal">${record.version}</span>
</div>



&nbsp;
<br/>
<br/>

<g:link controller="page" action="record" target="_blank"
        params="${[id: record.id, entityCode: entityCode]}"
        class=" fg-button fg-button-icon-solo ui-widget ui-state-default ui-corner-all"
        title="Go to page">
    <span class="ui-icon ui-icon-extlink"></span>

</g:link>

<br/>
<br/>

<br/>
%{--todo; case of x ,y--}%
<g:if test="${entityCode.size() >= 1 || (record.class.declaredFields.name.contains('deletedOn') && record.deletedOn != null)}">
    <g:remoteLink controller="generics" action="physicalDelete"
                  params="${[id: record.id, entityCode: entityCode]}"
                  update="${entityCode}Record${record.id}"
                  class=" fg-button fg-button-icon-solo ui-widget ui-state-default ui-corner-all"
                  before="if(!confirm('Are you sure you want to permanantly physically delete the record?')) return false"
                  title="Physical delete">
        <span class="ui-icon ui-icon-circle-close"></span>
    </g:remoteLink>
</g:if>


<g:if test="${entityCode.size() == 1 && record.class.declaredFields.name.contains('deletedOn')}">
    <g:if test="${!record.deletedOn}">

        <g:remoteLink controller="generics" action="logicalDelete"
                      params="${[id: record.id, entityCode: entityCode]}"
                      update="${entityCode}Record${record.id}"
                      before="if(!confirm('Are you sure you want to delete the record?')) return false"
                      class="fg-button fg-button-icon-solo ui-widget ui-state-default ui-corner-all"
                      title="Logical delete">
            <span class="ui-icon ui-icon-trash"></span>
        </g:remoteLink>
    </g:if>


    <g:else>

        <g:remoteLink controller="generics" action="logicalUndelete"
                      params="${[id: record.id, entityCode: entityCode]}"
                      update="${entityCode}Record${record.id}"
                      class=" fg-button fg-button-icon-solo ui-widget ui-state-default ui-corner-all"
                      title="Logical undelete">
            <span class="ui-icon ui-icon-closethick"></span>
        </g:remoteLink>
    </g:else>

    &nbsp;
</g:if>

<g:if test="${entityCode.size() > 1}">
    <g:remoteLink controller="generics" action="physicalDelete"
                  params="${[id: record.id, entityCode: entityCode]}"
                  update="${entityCode}Record${record.id}"
                  class=" fg-button fg-button-icon-solo ui-widget ui-state-default ui-corner-all"
                  title="Logical undelete">
        <span class="ui-icon ui-icon-circle-close"></span>
    </g:remoteLink>
</g:if>

<g:if test="${entityCode == 'N'}">
    &nbsp; &nbsp;Convert to &nbsp;
    <g:each in="${['J', 'P', 'R', 'W']}" var="t">

        <g:remoteLink controller="generics" action="convertNoteToRecord"
                      params="${[id: record.id, entityCode: entityCode, type: t]}"
                      update="${entityCode}Record${record.id}"
                      title="Convert note to ${t}">
            ${t}
        </g:remoteLink>
    </g:each>
</g:if>


<div id="notificationArea"></div>

<r:layoutResources/>
