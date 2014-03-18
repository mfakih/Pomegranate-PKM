<%@ page import="ker.OperationController; app.parameters.ResourceType; cmn.Setting; mcs.parameters.PlannerType; mcs.parameters.JournalType; mcs.Planner; mcs.Journal; mcs.parameters.ResourceStatus; mcs.Book" %>

<h3>Import location files</h3>

<table border="1" style="border-collapse: collapse">
<thead>
    <th>Resources and excerpts</th>
    <th>Smart files</th>
    </thead>
    <tr>
<td style="width: 50%">
<g:each in="${ResourceType.list()}" var="ry">

          <b>${ry.name}</b> @ ${ry.newFilesPath}
        <ul>

            <g:if test="${ry.newFilesPath && new File(ry.newFilesPath).exists()}">
                <g:each in="${new File(ry.newFilesPath).listFiles()}" var="i">
                    <g:if test="${i.isFile()}">
                        <li style="color: #096ca8; font-size: small">
                            ${i.name}
                        </li>
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
        Import
    </g:remoteLink>
    </div>
    <br/>
    <hr/>
    <br/>


</g:each>

    <b>Excerpts</b> @ ${OperationController.getPath('excerpts.sandbox.path')}<br/>
    Filename format: r [book id] [ch] [title] e.g. r 234 12 title of chapter.pdf
    <br/>
    <ul>

        <g:if test="${Setting.findByName('excerpts.sandbox.path') && new File(OperationController.getPath('excerpts.sandbox.path')).exists()}">
            <g:each in="${new java.io.File(OperationController.getPath('excerpts.sandbox.path')).listFiles()}" var="i">
                <g:if test="${i.isFile() && i.name.startsWith('r')}">
                    <li style="color: #096ca8; font-size: small">
                        ${i.name}
                    </li>
                </g:if>
            </g:each>
        </g:if>
        <g:else>
            Setting value "module.E.sandbox.path" is not defined or folder not exits
        </g:else>
    </ul>

    <div style="text-align: right;">
    <g:remoteLink controller="import" action="importExcerpts"
                  title="r [book id] [ch] [title]"
                  update="notificationArea">
        Import   </g:remoteLink>
        </div>




<g:each in="${['J','N']}" var="m">

    %{--<b>Excerpts</b> @ ${OperationController.getPath('excerpts.sandbox.path')}<br/>--}%
    Module:    ${m}

    <br/>
    <ul>

        <g:if test="${OperationController.getPath('module.' + m + '.sandbox.path') && new File(OperationController.getPath('module.' + m + '.sandbox.path')).exists()}">
            <g:each in="${new File(OperationController.getPath('module.' + m + '.sandbox.path')).listFiles()}" var="i">
                <g:if test="${i.isFile()}">
                    <li style="color: #096ca8; font-size: small">
                        ${i.name}
                    </li>
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
            Import   </g:remoteLink>
    </div>

</g:each>

</td>

<td style="vertical-align: top">

    %{--<g:remoteLink controller="import" action="importExcercises" update="notificationArea"--}%
    %{--title="c (#type?: 'hgl') b0000 ,pages ; title [ch, exe #, page, exe title]">--}%
    %{--Index card files--}%
    %{--<%-- ${grailsApplication.config.new.path}/ebk  --%>--}%
    %{--</g:remoteLink>--}%


        <g:if test="${Setting.findByName('smartFiles.newFiles.path') && new File(OperationController.getPath('smartFiles.newFiles.path')).exists()}">

            <ul>
                <g:each in="${new java.io.File(OperationController.getPath('smartFiles.newFiles.path')).listFiles()}"
                        var="i">
                    <g:if test="${i.isFile() && i.name.startsWith('n')}">
                        <li style="color: #096ca8; font-size: small">
                            ${i.name}
                        </li>
                    </g:if>
                </g:each>
            </ul>
        </g:if>
        <g:else>
           <i style="color: red"> Setting name "smartFiles.newFiles.path" is not defined or folder not exits
           </i>
            <br/>
        </g:else>

    <div style="text-align: right;">
    <g:remoteLink controller="import" action="importSmartFiles"
                  title="Import smart files"
                  update="notificationArea">
        Import
    </g:remoteLink>
        </div>


</td>




</tr>


</table>

