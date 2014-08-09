<%@ page import="org.apache.commons.lang.StringUtils; ker.OperationController; app.parameters.ResourceType; cmn.Setting; mcs.parameters.PlannerType; mcs.parameters.JournalType; mcs.Planner; mcs.Journal; mcs.parameters.ResourceStatus; mcs.Book" %>



%{--<h3>Import smart files</h3>--}%
       <g:render template="/import/uploadFiles"/>


<br/>
<br/>



<table border="0" style="border-collapse: collapse; width: 95%">


<tr>
<td style="vertical-align: top">

    %{--<g:remoteLink controller="import" action="importExcercises" update="notificationArea"--}%
    %{--title="c (#type?: 'hgl') b0000 ,pages ; title [ch, exe #, page, exe title]">--}%
    %{--Index card files--}%
    %{--<%-- ${grailsApplication.config.new.path}/ebk  --%>--}%
    %{--</g:remoteLink>--}%
           <h4>Smart files</h4>

        <g:if test="${Setting.findByName('smartFiles.sandbox.path') && new File(OperationController.getPath('smartFiles.sandbox.path')).exists()}">

            %{--<ul>--}%
                <g:each in="${new java.io.File(OperationController.getPath('smartFiles.sandbox.path')).listFiles()}"
                        var="i">
                    <g:if test="${i.isFile()}">
                        <div id="file${i.name.encodeAsMD5()}">
                        <g:formRemote name="importIndividualFile"
                                      url="[controller: 'import', action: 'importIndividualFile']"

                                      update="file${i.name.encodeAsMD5()}"

                                      onComplete="jQuery('#quickAddXcdField').val('')"
                                      method="post">
                            <g:hiddenField name="entityCode" value="${i.name?.substring(0,1)?.toUpperCase()}"></g:hiddenField>
                            <g:hiddenField name="type" value="${null}"></g:hiddenField>
                            <g:hiddenField name="name" value="${i.name}"></g:hiddenField>
                            <g:hiddenField name="smart" value="yes"></g:hiddenField>
                            <g:hiddenField name="path"
                                           value="${OperationController.getPath('smartFiles.sandbox.path') + '/' + i.name}">

                            </g:hiddenField>
                            <g:actionSubmit value="+"/>

                             <span id="${i.name.encodeAsMD5()}">   ${i.name}
                             </span>
                             <br/><br/>
                             <script>
                             jQuery("#notificationAreaHidden").load('generics/verifySmartFileName', {'line': "${i.name}"}, function( response, status, xhr ) {jQuery("#${i.name.encodeAsMD5()}").attr('class', response);})  
                             
                             </script>



                        </g:formRemote>
                           </g:if>

                    </div>
                </g:each>
            %{--</ul>--}%
        </g:if>
        <g:else>
           <i style="color: red"> Setting name 'smartFiles.sandbox.path' is not defined or folder not exits.
           </i>
            <br/>
        </g:else>

    %{--<div style="text-align: right;">--}%
    %{--<g:remoteLink controller="import" action="importSmartFiles"--}%
                  %{--title="Import smart files"--}%
                  %{--update="notificationArea">--}%
        %{--Import all--}%
    %{--</g:remoteLink>--}%
        %{--</div>--}%


</td>




</tr>



%{--<thead>--}%
    %{--<th>Resources and excerpts</th>--}%
    %{--<th>Smart files</th>--}%
    %{--</thead>--}%
    <tr>
<td style="width: 99%">
<g:each in="${ResourceType.list()}" var="ry">

        %{--<ul>--}%

            <g:if test="${ry.newFilesPath && new File(ry.newFilesPath).exists() && new File(ry.newFilesPath).size() > 0}">
                <h4>${ry.name}</h4>
                <!-- @ ${ry.newFilesPath}-->
                <g:each in="${new File(ry.newFilesPath).listFiles()}" var="i">
                    <g:if test="${i.isFile()}">
                        <div id="file${i.name.encodeAsMD5()}">
                        <g:formRemote name="importIndividualFile"
                                      url="[controller: 'import', action: 'importIndividualFile']"
                                      update="file${i.name.encodeAsMD5()}"

                                      onComplete="jQuery('#quickAddXcdField').val('')"
                                      method="post">
                            <g:hiddenField name="entityCode" value="R"></g:hiddenField>
                            <g:hiddenField name="smart" value="no"></g:hiddenField>
                            <g:hiddenField name="type" value="${ry.code}"></g:hiddenField>
                            <g:hiddenField name="name" value="${i.name}"></g:hiddenField>
                            <g:hiddenField name="path"
                                           value="${ry.newFilesPath + '/' + i.name}"></g:hiddenField>
                            <g:hiddenField name="parentPath"
                                           value="${ry.newFilesPath}"></g:hiddenField>
                                           
                          <g:actionSubmit value="+"></g:actionSubmit>                 
                                             ${i.name} <span style="color: gray" id="${i.name.encodeAsMD5()}">  
                             </span>
                           
                             <script>
                             jQuery("#${i.name.encodeAsMD5()}").load('generics/getIsbnInfo', {'line': "${i.name}"})
                             
                             </script>

                            
                          
                            
   <br/> <br/><br/>
                        </g:formRemote>
                        </div>
                    </g:if>
                </g:each>
         
    %{--<g:else>--}%
            %{--<i style="color: red">Resource type folder "${ry.newFilesPath}" is not defined or does not exists.</i>--}%
        %{--</g:else>--}%
        %{--</ul>--}%
   <br/>
    %{--<div style="text-align: right;">--}%
    %{--<g:remoteLink controller="import" action="importResources" update="notificationArea"--}%
                  %{--params="[type: ry.id]">--}%
        %{--Import all--}%
    %{--</g:remoteLink>--}%
    %{--</div>--}%
    %{--<br/>--}%
  
    <br/>
   </g:if>

</g:each>




<g:each in="${['G', 'T', 'P', 'J', 'I', 'Q', 'W', 'N', 'E']}" var="m">

    %{--<b>Excerpts</b> @ ${OperationController.getPath('excerpts.sandbox.path')}<br/>--}%

    %{--<br/>--}%
    %{--<ul>--}%

        <g:if test="${OperationController.getPath('module.sandbox.' + m + '.path') && new File(OperationController.getPath('module.sandbox.' + m + '.path')).exists() && new File(OperationController.getPath('module.sandbox.' + m + '.path')).size() > 0}">
            <h4>  Module ${m} </h4>
            <!--@ ${OperationController.getPath('module.sandbox.' + m + '.path')}-->
            <g:each in="${new File(OperationController.getPath('module.sandbox.' + m + '.path')).listFiles()}" var="i">
                <g:if test="${i.isFile()}">
                    <div id="file${i.name.encodeAsMD5()}">

                    <g:formRemote name="importIndividualFile"
                                  url="[controller: 'import', action: 'importIndividualFile']"

                                  update="file${i.name.encodeAsMD5()}"

                                  onComplete="jQuery('#quickAddXcdField').val('')"
                                  method="post">
                        <g:hiddenField name="entityCode" value="${m}"></g:hiddenField>
                        <g:hiddenField name="type" value="${null}"></g:hiddenField>
                        <g:hiddenField name="name" value="${i.name}"></g:hiddenField>
                        <g:hiddenField name="smart" value="no"></g:hiddenField>
                        <g:hiddenField name="path" value="${OperationController.getPath('module.sandbox.' + m + '.path') + '/' + i.name}"></g:hiddenField>
                        <g:actionSubmit value="+"></g:actionSubmit>
                        ${i.name}


                   </g:formRemote>

                    </div>
%{--<br/>--}%
<br/>
                </g:if>
            </g:each>
     
        %{--<g:else>--}%
            %{--Setting value 'module.sandbox.${m}.path' is not defined or folder not exits--}%
        %{--</g:else>--}%
    %{--</ul>--}%

    %{--<div style="text-align: right;">--}%
        %{--<g:remoteLink controller="import" action="importModuleFiles" params="[module: m]"--}%
                      %{--title="r [book id] [ch] [title]"--}%
                      %{--update="notificationArea">--}%
            %{--Import all--}%
        %{--</g:remoteLink>--}%
        %{--&nbsp;--}%
    %{--</div>--}%
    %{--<br/>--}%
  %{--<hr/>--}%
         </g:if>
</g:each>

</td>
  </tr>


</table>

