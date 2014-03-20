<%@ page import="ker.OperationController; app.parameters.ResourceType; cmn.Setting; mcs.parameters.PlannerType; mcs.parameters.JournalType; mcs.Planner; mcs.Journal; mcs.parameters.ResourceStatus; mcs.Book" %>

<h3>Import local files</h3>

<table border="1" style="border-collapse: collapse">
%{--<thead>--}%
    %{--<th>Resources and excerpts</th>--}%
    %{--<th>Smart files</th>--}%
    %{--</thead>--}%
    <tr>
<td style="width: 99%">
<g:each in="${ResourceType.list()}" var="ry">

          <b>${ry.name}</b> @ ${ry.newFilesPath}
        <ul>

            <g:if test="${ry.newFilesPath && new File(ry.newFilesPath).exists()}">
                <g:each in="${new File(ry.newFilesPath).listFiles()}" var="i">
                    <g:if test="${i.isFile()}">
                        <g:formRemote name="importIndividualFile"
                                      url="[controller: 'import', action: 'importIndividualFile']"

                                      update="file${i.name.replaceAll(' ', '').replace(',', '')}"

                                      onComplete="jQuery('#quickAddXcdField').val('')"
                                      method="post">
                            <g:hiddenField name="entityCode" value="E"></g:hiddenField>
                            <g:hiddenField name="smart" value="yes"></g:hiddenField>
                            <g:hiddenField name="type" value="${ry.code}"></g:hiddenField>
                            <g:hiddenField name="name" value="${i.name}"></g:hiddenField>
                            <g:hiddenField name="path"
                                           value="${ry.path + '/' + i.name}"></g:hiddenField>
                            ${i.name}
                            <g:actionSubmit value="+"></g:actionSubmit>

                        </g:formRemote>
                    </g:if>
                </g:each>
            </g:if><g:else>
            <i style="color: red">Resource type folder "${ry.newFilesPath}" is not defined or does not exists.</i>
        </g:else>
        </ul>
   <br/>
    <div style="text-align: right;">
    <g:remoteLink controller="import" action="importResources" update="notificationArea"
                  params="[type: ry.id]">
        Import all
    </g:remoteLink>
    </div>
    <br/>
    <hr/>
    <br/>


</g:each>




<g:each in="${['G', 'T', 'P', 'J', 'I', 'Q', 'W', 'N', 'E']}" var="m">

    %{--<b>Excerpts</b> @ ${OperationController.getPath('excerpts.sandbox.path')}<br/>--}%
  <h4>  Module:    ${m} @ ${OperationController.getPath('module.' + m + '.sandbox.path')}</h4>

    <br/>
    <ul>

        <g:if test="${OperationController.getPath('module.' + m + '.sandbox.path') && new File(OperationController.getPath('module.' + m + '.sandbox.path')).exists()}">
            <g:each in="${new File(OperationController.getPath('module.' + m + '.sandbox.path')).listFiles()}" var="i">
                <g:if test="${i.isFile()}">
                    <div id="file${i.name.replaceAll(' ', '').replace(',', '')}">

                    <g:formRemote name="importIndividualFile"
                                  url="[controller: 'import', action: 'importIndividualFile']"

                                  update="file${i.name.replaceAll(' ', '').replace(',', '')}"

                                  onComplete="jQuery('#quickAddXcdField').val('')"
                                  method="post">
                        <g:hiddenField name="entityCode" value="${m}"></g:hiddenField>
                        <g:hiddenField name="type" value="${null}"></g:hiddenField>
                        <g:hiddenField name="name" value="${i.name}"></g:hiddenField>
                        <g:hiddenField name="path" value="${OperationController.getPath('module.' + m + '.sandbox.path') + '/' + i.name}"></g:hiddenField>
                        <g:actionSubmit value="+"></g:actionSubmit> ${i.name}


                   </g:formRemote>

                    </div>
<br/>
<br/>
                </g:if>
            </g:each>
        </g:if>
        <g:else>
            Setting value 'module.${m}.sandbox.path' is not defined or folder not exits
        </g:else>
    </ul>

    <div style="text-align: right;">
        <g:remoteLink controller="import" action="importModuleFiles" params="[module: m]"
                      title="r [book id] [ch] [title]"
                      update="notificationArea">
            Import all
        </g:remoteLink>
        &nbsp;
    </div>
    <br/>
  <hr/>
</g:each>

</td>
  </tr>
<tr>
<td style="vertical-align: top">

    %{--<g:remoteLink controller="import" action="importExcercises" update="notificationArea"--}%
    %{--title="c (#type?: 'hgl') b0000 ,pages ; title [ch, exe #, page, exe title]">--}%
    %{--Index card files--}%
    %{--<%-- ${grailsApplication.config.new.path}/ebk  --%>--}%
    %{--</g:remoteLink>--}%


        <g:if test="${Setting.findByName('smartFiles.sandbox.path') && new File(OperationController.getPath('smartFiles.sandbox.path')).exists()}">

            <ul>
                <g:each in="${new java.io.File(OperationController.getPath('smartFiles.sandbox.path')).listFiles()}"
                        var="i">
                    <g:if test="${i.isFile()}">

                        <g:formRemote name="importIndividualFile"
                                      url="[controller: 'import', action: 'importIndividualFile']"

                                      update="file${i.name.replaceAll(' ', '').replace(',', '')}"

                                      onComplete="jQuery('#quickAddXcdField').val('')"
                                      method="post">
                            <g:hiddenField name="entityCode" value="${m}"></g:hiddenField>
                            <g:hiddenField name="type" value="${null}"></g:hiddenField>
                            <g:hiddenField name="name" value="${i.name}"></g:hiddenField>
                            <g:hiddenField name="path"
                                           value="${OperationController.getPath('smartFiles.sandbox.path') + '/' + i.name}">

                            </g:hiddenField>
                            <g:actionSubmit value="+">

                                ${i.name}


                            </g:actionSubmit>

                        </g:formRemote>


                    </g:if>
                </g:each>
            </ul>
        </g:if>
        <g:else>
           <i style="color: red"> Setting name 'smartFiles.sandbox.path' is not defined or folder not exits.
           </i>
            <br/>
        </g:else>

    <div style="text-align: right;">
    <g:remoteLink controller="import" action="importSmartFiles"
                  title="Import smart files"
                  update="notificationArea">
        Import all
    </g:remoteLink>
        </div>


</td>




</tr>


</table>

