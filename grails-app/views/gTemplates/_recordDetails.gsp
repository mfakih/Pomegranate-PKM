<%@ page import="org.apache.commons.lang.StringUtils; ker.OperationController; app.parameters.Blog; org.ocpsoft.prettytime.PrettyTime; cmn.Setting; ys.wikiparser.WikiParser; mcs.Journal; app.Payment; app.IndicatorData; app.IndexCard; mcs.Excerpt; mcs.Planner; java.text.DecimalFormat" %>
<g:set var="entityCode"
       value="${record.metaClass.respondsTo(record, 'entityCode') ? record.entityCode() : record.class?.name?.split(/\./).last()}"/>

<g:if test="${session['showLine1Only'] == 'on'}">
<g:render template="/gTemplates/2ndLine" model="[record: record, entityCode: entityCode]"/>
    </g:if>

%{--<r:require module="fileuploader"/>--}%
%{--<r:layoutResources/>--}%


<div class="recordDetailsBody" style="margin-left: 5px;" id="detailsRegion${record.entityCode()}${record.id}">

       <table style="border-collapse: collapse; width: 99%" border="0">
           <tr style="width: 99%">
               <td style="width: 60%; vertical-align: top">

<g:if test="${'T'.contains(record.entityCode())}">
                   %{--<g:render template="/tag/addContact" model="[instance: record, entity: record.entityCode()]"/>--}%
</g:if>

                   <div style="padding: 8px; font-size: 11px; font-family: georgia; margin: 2px; line-height: 20px; text-align: justify">
                   <g:if test="${record.class.declaredFields.name.contains('description')}">
                       <g:remoteLink controller="page" action="panel"
                                     params="${[id: record.id, entityCode: entityCode]}"
                                     update="3rdPanel"
                                     title="Read the full text">
                       ${StringUtils.abbreviate(record.description?.replaceAll('\n', '<br/>')?.replace('Product Description', '')?.decodeHTML(), 240)}
                       </g:remoteLink>
                   </g:if>
                   </div>


                       %{--<br/>--}%
                       %{--<g:if test="${record.publishedNodeId}">--}%
                       %{--<br/>--}%
                       %{--Posted on ${record.blogCode} with ID ${record.publishedNodeId} on ${record.publishedOn?.format('dd.MM.yyyy HH:mm')}--}%
                       %{--<br/>--}%
                       %{--</g:if>--}%


                   <g:if test="${'R'.contains(record.entityCode())}">
                   %{--<b>${record.title?.encodeAsHTML()?.replaceAll('\n', '<br/>')}</b>--}%
                   %{--<br/>--}%
                       <div style="padding: 3px; font-size: 13px; font-family: tahoma; margin: 5px; line-height: 20px">
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

                           <g:if test="${record?.type?.code == 'link'}">
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

               </td>

           <td style="width: 40%; vertical-align: top">



<g:render template="/tag/addTag" model="[instance: record, entity: record.entityCode()]"/>

<g:if test="${'TGRE'.contains(record.entityCode())}">
    <h4>Add journal or planner record</h4>
    <g:formRemote name="scheduleTask" url="[controller: 'task', action: 'assignRecordToDate']"
                  style="display: inline;" update="below${record.entityCode()}Record${record.id}"
                  method="post">
        Type/Level/Weight
        <br/>
        <g:select name="type" from="['J', 'P']" value="P"/>
        <g:select name="level" from="['e', 'y', 'M', 'W', 'd', 'm']" value="d"/>
        <g:select name="weight" from="${1..4}" value="1"/>
        <input type="text" name="date" title="Format: wwd [hh]" placeholder="Date"
               style="width: 70px;"
               value="${mcs.Utils.toWeekDate(new Date())}"/>
        <input type="text" name="summary" title="" placeholder="Summary"
               style="width: 200px;"
               value=""/>


        <g:hiddenField name="recordType" value="${record.entityCode()}"/>
        <g:hiddenField name="recordId" value="${record.id}"/>
        <g:submitButton name="scheduleTask" value="ok" style="display: none;"
                        class="fg-button ui-widget ui-state-default ui-corner-all"/>
    </g:formRemote>
    <br/>
    <br/>
</g:if>

<h4>Relate</h4>
<span id="addRelationship${record.id}" style="display: inline;">
    <g:render template="/gTemplates/addRelationships"
              model="[record: record, entity: record.entityCode()]"/>
</span>


<div id="publish${record.id}" style="display: inline;  margin-left: 10px;">
<!--todo-->
<g:if test="${'N'.contains(entityCode)}">
<div id="postResult${record.id}" style="display: inline">
    <g:if test="${record.blog?.code}">
        <g:remoteLink controller="generics" action="publish" id="${record.id}"
                      params="[entityCode: entityCode]"
                      update="postResult${record?.id}"
                      title="Publish record"
                      class="fg-button ui-widget ui-state-default ui-corner-all">
            Publish on <b>${record.blog?.code}</b>
        </g:remoteLink>
    </g:if>
</div>


    <br/><br/>
<div id="syncResult${record.id}" style="display: inline">

    <g:if test="${record.pomegranate?.code}">
        <g:remoteLink controller="export" action="syncNote" id="${record.id}"
                      params="[entityCode: entityCode]"
                      update="syncResult${record?.id}"
                      title="Sync record"
                      class="fg-button ui-widget ui-state-default ui-corner-all">
            Sync on <b>${record.pomegranate?.code}</b>
        </g:remoteLink>
    </g:if>

</div>
    </g:if>
<g:if test="${1 == 2}">
    <g:formRemote name="setBlogCode" style="display: inline"
                  url="[controller: 'generics', action: 'setRecordBlog', params: [id: record.id, entityCode: record.entityCode()]]"
                  update="notificationArea"
                  title="Post info">
        <g:select from="${Blog.list()}" name="blog.id" title="Blog"
                  value="${record.blog?.id}"/>
        <g:textField id="publishedNodeId" name="publishedNodeId" style="width: 30px"
                     class="ui-corner-all"
                     title="Post ID" placeholder="Post ID"
                     value="${record?.publishedNodeId}"/>
        <g:textField id="publishedOn" name="publishedOn" style="width: 80px"
                     class="ui-corner-all" placeholder="Post date" title="Post date"
                     value="${record.publishedOn ? record.publishedOn?.format('dd.MM.yyyy') : new Date().format('dd.MM.yyyy')}"/>

        <g:submitButton name="add" value="Set" style=""
                        class="fg-button  ui-widget ui-state-default ui-corner-all"/>
    </g:formRemote>
</g:if>
  </div>


               <g:if test="${record.entityCode() == 'N'}">
                       <pkm:listFiles
                               folder="${OperationController.getPath('module.sandbox.N.path')}"
                               initial="${record.id}n"/>

                       <pkm:listAudios fileClass="vxrFile"
                                       folder="${OperationController.getPath('module.sandbox.N.path')}"
                                       initial="${record.id}n"/>


                       <pkm:listFiles
                               folder="${OperationController.getPath('module.sandbox.N.path')}"
                               initial="${record.id}n"/>

                   </g:if>
                   <g:if test="${record.entityCode() == 'E'}">
                       <pkm:listFiles fileClass="himFile"
                                      folder="${OperationController.getPath('module.repository.E.path')}"
                                      initial="${record.id}r"/>
                       <pkm:listFiles fileClass="newFile"
                                      folder="${OperationController.getPath('module.sandbox.E.path')}"
                                      initial="${record.id}r"/>

                   </g:if>

                   <g:if test="${new File(OperationController.getPath('covers.sandbox.path') + '/' +
                           entityCode + '/' + record.id + '.jpg')?.exists() || new File(OperationController.getPath('covers.repository.path') + '/' + entityCode + '/' + record.id + '.jpg')?.exists()}">
                       <br/><br/>
                       <a href="${createLink(controller: 'book', action: 'viewImage', id: record.id)}"
                          target="_blank">
                           <img class="Photo" style="width: 100; height: 130; display:inline"
                                src="${createLink(controller: 'book', action: 'viewImage', id: record.id, params: [date: new Date()])}"/>
                       </a>
                   </g:if>

                   <g:if test="${record.entityCode() == 'R'}">

                       <g:if test="${record.entityCode() == 'B' && (new File(OperationController.getPath('covers.sandbox.path') + '/' +
                               record?.type?.code + '/' + record.id + '.jpg')?.exists() || new File(OperationController.getPath('covers.repository.path') + '/' + record?.type?.code + '/' + record.id + '.jpg')?.exists())}">
                           <br/><br/>
                           <a href="${createLink(controller: 'book', action: 'viewImage', id: record.id)}"
                              target="_blank">
                               <img class="Photo" style="width: 100; height: 130; display:inline"
                                    src="${createLink(controller: 'book', action: 'viewImage', id: record.id, params: [date: new Date()])}"/>
                           </a>
                       </g:if>
                       <br/>
                       <br/>
                       <g:if test="${Setting.findByName('aws.secret.key')}">
                           <g:remoteLink controller="book" action="updateBookInfo" id="${record.id}"
                                         update="RRecord${record.id}"
                                         class="actionLink"
                                         title="Update metadata">
                               Update metadata from Amazon
                           </g:remoteLink>
                           <br/>
                           <br/>
                       </g:if>



                       <br/>
                       <pkm:listFiles fileClass="himFile"
                                      folder="${record?.type?.repositoryPath}/${(record.id / 100).toInteger()}"
                                      initial="${record.id}[a-z]"/>
                   %{--${record.resourceType == 'ebk' ? 'b' : (record.resourceType == 'art' ? 'a' : 'n')}--}%

                       <pkm:listFiles fileClass="himFile"
                                      folder="${record?.type?.repositoryPath}/${(record.id / 100).toInteger()}/${record.id}"
                                      initial=""/>
                       <pkm:listFiles fileClass="vxrFile"
                                      folder="${OperationController.getPath('video.excerpts.repository.path')}/${record.resourceType}/${record.id}"
                                      initial=""/>

                       %{--<pkm:listFiles fileClass="libFile"--}%
                                      %{--folder="/todo/lib/${record?.type?.code}/${(record.id / 100).toInteger()}"--}%
                                      %{--initial="${record.id}[a-z]"/>--}%
                       %{--<pkm:listFiles fileClass="libFile"--}%
                                      %{--folder="/todo/lib/${record?.type?.code}/${(record.id / 100).toInteger()}"--}%
                                      %{--initial="${record.id}[a-z]"/>--}%
                       <pkm:listFiles fileClass="libFile"
                                       folder="${record?.type?.repositoryPath}/${(record.id / 100).toInteger()}/${record.id}"
                                       initial=""/>
                       <pkm:listFiles fileClass="himFile"
                                      folder="${record?.type?.repositoryPath}/${record.resourceType}-${record.id}"
                                      initial=""/>


                       <pkm:listFiles fileClass="libFile"
                                      folder="${record?.type?.repositoryPath}/${record.resourceType}-${record.id}"
                                      initial=""/>

                       <pkm:listFiles fileClass="newFile"
                                      folder="${record?.type?.newFilesPath}/${(record.id / 100).toInteger()}"
                                      initial="${record.id}[a-z]"/>

                       <pkm:listFiles fileClass="newFile"
                                      folder="${record?.type?.newFilesPath}/${(record.id / 100).toInteger()}/${record.id}"
                                      initial=""/>



                       <pkm:listVideos fileClass="vxrFile"
                                       folder="${OperationController.getPath('vxr.path')}/${record.type?.code}/${record.id}"
                                       initial=""/>

                       <pkm:listAudios fileClass="vxrFile"
                                       folder="${OperationController.getPath('audio.excerpts.repository.path')}/${record.type?.code}/${record.id}"
                                       initial=""/>



                       <pkm:listPictures fileClass="snsFile"
                                         folder="${OperationController.getPath('video.snapshots.repository.path')}/${record.entityCode()}/${record.id}"
                                         initial=""/>



                       <g:if test="${record.withAudiobook}">

                           <pkm:listFiles fileClass="vxrFile"
                                          folder="${OperationController.getPath('audiobooks.repository.path')}/${record.id}"
                                          initial=""/>

                           <pkm:listFiles fileClass="abkFile"
                                          folder="${OperationController.getPath('audio.excerpts.repository.path')}/${record.type?.code}/${record.id}"
                                          initial=""/>

                       </g:if>

                   %{--<br/>--}%
                   %{--<pkm:listFiles--}%
                   %{--folder="/new/${record.resourceType}/${new DecimalFormat('00000').format(record.id).substring(0, 2)}"--}%
                   %{--initial="${new DecimalFormat('0000').format(record.id)}${record.resourceType == 'ebk' ? 'b' : 'a'}"></pkm:listFiles>--}%

                   </g:if>


                   <pkm:listPictures fileClass="snsFile"
                                     folder="${OperationController.getPath('pictures.repository.path')}/${record.entityCode()}/${record.id}"
                                     initial=""/>


           <br/>
           <br/>


                                                     %{--todo; case of x ,y--}%
                   <g:if test="${entityCode.size() >= 1 || (record.class.declaredFields.name.contains('deletedOn') && record.deletedOn != null)}">
                       <g:remoteLink controller="generics" action="physicalDelete"
                                     params="${[id: record.id, entityCode: entityCode]}"
                                     update="${entityCode}Record${record.id}"
                                     class=" fg-button fg-button-icon-left ui-widget ui-state-default ui-corner-all"
                                     before="if(!confirm('Are you sure you want to permanantly delete the record?')) return false"
                                     title="Physical delete">
                           <span class="ui-icon ui-icon-circle-close"></span> Physical delete
                       </g:remoteLink>
                   </g:if>



               </td>
           </tr>
       </table>


   <g:if test="${1==2}">
<div id="addNote${record.id}" style="display: inline; ">
    <g:formRemote name="addNote" url="[controller: 'generics', action: 'addNote']"
                  update="notes${record.entityCode()}${record.id}"
                  style="display: inline;">
        <g:hiddenField name="id" value="${record.id}"/>
        <g:hiddenField name="entityCode" value="${record.entityCode()}"/>
        <g:textField id="newNote${record.entityCode()}${record.id}" name="note" class="ui-corner-all" placeholder="Append to notes..."
                     style="width:100px; display: inline; " value=""/>
        <g:submitButton name="add" value="add" style="display:none;"
                        class="fg-button  ui-widget ui-state-default ui-corner-all"/>
    </g:formRemote>
</div>
   </g:if>







</div>


<div id="relationshipRegion${record.entityCode()}${record.id}">
    <g:render template="/gTemplates/relationships" model="[record: record, entity: record.entityCode()]"/>
</div>


<g:if test="${record.entityCode() == 'L'}">

    <g:render template="/gTemplates/recordListing"
              model="[list: Payment.findAllByCategory(record, [sort: 'date', order: 'desc'])]"/>

</g:if>

<g:if test="${record.entityCode() == 'I'}">

    <div id="graph${record.id}" style="width: 500px; height: 200px; margin: 3px auto 0 auto;"></div>

    <script type="text/javascript">

        var day_data = [
            <% IndicatorData.findAllByIndicator(record).eachWithIndex(){ h, i -> if (i != IndicatorData.countByIndicator(record) - 1) { %>
            {"date": "${h.date.format('yyyy-MM-dd')}", "Value": ${h.value}},
            <% } else { %>
            {"date": "${h.date.format('yyyy-MM-dd')}", "Value": ${h.value}}
            <% }}  %>
            //        {"period":"2012-09-10", "pln total":12, "pln completed":10}
        ];
        Morris.Line({
            element: 'graph${record.id}',
            data: day_data,
            xkey: 'date',
            ykeys: ['Value'],
            ymin: 'auto',
            hideHover: 'true',
            labels: ['Value'],
            /* custom label formatting with `xLabelFormat` */
            xLabelFormat: function (d) {
                return  d.getDate() + '.' + (d.getMonth() + 1) //+ '/' + d.getDate() + '/' + d.getFullYear();
            },
            /* setting `xLabels` is recommended when using xLabelFormat */
            xLabels: 'day'
        });

    </script>


    <g:render template="/gTemplates/recordListing"
              model="[list: IndicatorData.findAllByIndicator(record, [sort: 'date', order: 'desc'])]"/>

</g:if>

<g:if test="${record.entityCode() == 'P'}">

    <g:if test="${record.completedOn}">
        Completed on: ${record.completedOn?.format('dd.MM.yyyy')}
    </g:if>
    <g:if test="${record.task}">
        <g:render template="/gTemplates/recordSummary" model="[record: record.task]"/>
    </g:if>
    <g:if test="${record.goal}">
        <g:render template="/gTemplates/recordSummary" model="[record: record.goal]"/>
    </g:if>
</g:if>

<g:if test="${record.entityCode() == 'T'}">
    <g:render template="/gTemplates/recordListing" model="[list: Planner.findAllByTask(record)]"/>
    <g:render template="/gTemplates/recordListing" model="[list: Journal.findAllByTask(record)]"/>
</g:if>

<g:if test="${record.entityCode() == 'R'}">
 %{--<h4>J & P</h4>--}%
    <g:render template="/gTemplates/recordListing" model="[list: Planner.findAllByBook(record)]"/>
    <g:render template="/gTemplates/recordListing" model="[list: Journal.findAllByBook(record)]"/>

</g:if>


<g:if test="${record.entityCode() == 'E'}">
    %{--<h4>J & P</h4>--}%
    <g:render template="/gTemplates/recordListing" model="[list: Planner.findAllByExcerpt(record)]"/>
    <g:render template="/gTemplates/recordListing" model="[list: Journal.findAllByExcerpt(record)]"/>

</g:if>

<g:if test="${record.entityCode() == 'G'}">
    %{--<h4>J & P</h4>--}%
    <g:render template="/gTemplates/recordListing" model="[list: Planner.findAllByGoal(record)]"/>
    <g:render template="/gTemplates/recordListing" model="[list: Journal.findAllByGoal(record)]"/>

</g:if>

%{--<g:render template="/indexCard/add"--}%
%{--model="[indexCardInstance: new IndexCard(), recordEntityCode: record.entityCode(), recordId: record.id]"/>--}%




%{--<a class="actionLink" onclick="jQuery('#addRelationship${record.id}').removeClass('navHidden')">Relate...</a>--}%
%{--<a class="actionLink" onclick="jQuery('#addNote${record.id}').removeClass('navHidden')">Add note...</a>--}%
%{--<g:if test="${'JWC'.contains(record.entityCode())}">--}%
    <!--<a class="actionLink" onclick="jQuery('#publish${record.id}').removeClass('navHidden')">Publish...</a>-->
%{--</g:if>--}%



<g:if test="${record.class.declaredFields.name.contains('notes')}">
<div id="notes${record.entityCode()}${record.id}" style="display: inline;">

    <g:if test="${record.notes}">
    %{--<br/>--}%
        <g:render template="/gTemplates/recordNotes" model="[record: record]"/>

    </g:if>
</div>
    </g:if>


<div style="font-size: 11px;">
    <br/>

    <b> Updated </b>${record.lastUpdated?.format(OperationController.getPath('date.format') ?: 'dd.MM.yyyy')} (<prettytime:display
        date="${record.lastUpdated}"/>)

%{--(<prettytime:display--}%
%{--date="${record.dateCreated}"/>)--}%
%{--by ${record.insertedBy}--}%
%{--editedBy ${record.editedBy}--}%
    <b>  Created </b>${record.dateCreated?.format(OperationController.getPath('date.format') ?: 'dd.MM.yyyy')}
(${new PrettyTime()?.format(record.dateCreated)})
    <br/>
    <b>Version</b> <span style="font-weight: normal">${record.version}</span>
</div>

