<%@ page import="ker.OperationController; mcs.Course; mcs.Department; org.apache.commons.lang.StringUtils; cmn.Setting" %>



<g:if test="${OperationController.getPath('coursesPanel.enabled')?.toLowerCase() == 'yes' ? true : false}">
<div class="accordionHeader" onclick="toggleAdd('#accordionCourses', 'coursesPanel')">Projects & Courses</div>

 </g:if>
<div class="accordionHeader" onclick="toggleAdd('#accordionAdd', 'addPanel')">Administration</div>


<div id="accordionAdd" style="width: 200px; padding: 3px;">



<h3 class="">
    <a>
        Quick add
    </a>
</h3>

<div>

    <b>Type:</b> <g:formRemote name="batchAdd2"
                               url="[controller: 'generics', action: 'quickAddRecord']"
                               update="centralArea" style="display: inline;"

                               onComplete="jQuery('quickAddNote').val('')"
                               method="post">
    <g:select name="recordType"
              from="${  [

                      [enabled: OperationController.getPath('goals.enabled')?.toLowerCase() == 'yes', code: 'G', name: 'Goals'] ,
                      [ enabled : OperationController . getPath ( 'tasks.enabled' ) ?. toLowerCase ( ) == 'yes' , code : 'T' , name : 'Tasks' ] ,
                      [ enabled : OperationController . getPath ( 'planner.enabled' ) ?. toLowerCase ( ) == 'yes' , code : 'P' , name : 'Planner' ] ,
                      [ enabled : OperationController . getPath ( 'journal.enabled' ) ?. toLowerCase ( ) == 'yes' , code : 'J' , name : 'Journal' ] ,
                      [ enabled : OperationController . getPath ( 'writings.enabled' ) ?. toLowerCase ( ) == 'yes' , code : 'W' , name : 'Writing' ] ,
                      [ enabled : OperationController . getPath ( 'notes.enabled' ) ?. toLowerCase ( ) == 'yes' , code : 'N' , name : 'Notes' ] ,
                      [ enabled : OperationController . getPath ( 'resources.enabled' ) ?. toLowerCase ( ) == 'yes' , code : 'R' , name : 'Resources' ],
                      [ enabled : OperationController . getPath ( 'contacts.enabled' ) ?. toLowerCase ( ) == 'yes' , code : 'S' , name : 'Contact' ]
              ].grep { it . enabled == true }
              }" optionKey="code" optionValue="name"
              style="direction: ltr; text-align: left; display: inline;"
              onchange="jQuery('#searchForm').load('generics/hqlSearchForm/' + this.value);"
              value="N"/>



    <g:textArea cols="80" rows="5" name="block" id="quickAddRecordTextArea"
                value=""
                style="width: 90%; height: 60px;  margin: 4px;"

                placeholder="Contents..."/>
%{--style="width:650px; min-width:650px !important; height: 70px;
 font-family: Source Sans Pro,Helvetica,Arial,sans-serif; background: #eeeeee; margin: 4px;"                --}%

    <g:submitButton name="batch" value="Save" id="quickAddRecordSubmit"
                    style=""
                    class="fg-button  ui-widget ui-state-default"/>

</g:formRemote>
</div>


<h3 class="">
    <a>
        Detailed add
    </a>
</h3>

<div>

    <ul style="list-style: square">

        <g:each in="${
            [

                    [enabled: OperationController.getPath('goals.enabled')?.toLowerCase() == 'yes', code: 'G', name: 'Goals', controller: 'mcs.Goal'],
                    [enabled: OperationController.getPath('tasks.enabled')?.toLowerCase() == 'yes', code: 'T', name: 'Tasks', controller: 'mcs.Task'],
                    [enabled: OperationController.getPath('planner.enabled')?.toLowerCase() == 'yes', code: 'P', name: 'Planner', controller: 'mcs.Planner'],
                    [enabled: OperationController.getPath('journal.enabled')?.toLowerCase() == 'yes', code: 'J', name: 'Journal', controller: 'mcs.Journal'],
                    [enabled: OperationController.getPath('indicators.enabled')?.toLowerCase() == 'yes', code: 'I', name: 'Indicator', controller: 'app.IndicatorData'],
                    [enabled: OperationController.getPath('Payment.enabled')?.toLowerCase() == 'yes', code: 'Q', name: 'Payment', controller: 'app.Payment'],
                    [enabled: OperationController.getPath('writings.enabled')?.toLowerCase() == 'yes', code: 'W', name: 'Writing', controller: 'mcs.Writing'],
                    [enabled: OperationController.getPath('notes.enabled')?.toLowerCase() == 'yes', code: 'N', name: 'Notes', controller: 'app.IndexCard',],
                    [enabled: OperationController.getPath('resources.enabled')?.toLowerCase() == 'yes', code: 'R', name: 'Resources', controller: 'mcs.Book'],
                    [enabled: OperationController.getPath('contacts.enabled')?.toLowerCase() == 'yes', code: 'S', name: 'Contact', controller: 'app.Contact']
            ].grep { it.enabled == true }
        }"
                var="i">
        %{--todo--}%

            <g:remoteLink controller="generics" action="getAddForm"
                          params="[entityController: i.controller, updateRegion: 'centralArea']"
                          update="centralArea">
                <li>
                    <span style="font-size: 12px; padding: 2px;">
                        <b>${i.code}</b> ${i.name}
                    </span>
                </li>
            </g:remoteLink>

        </g:each>
    </ul>

</div>

%{--<g:if test="${OperationController.getPath('import.enabled')?.toLowerCase() == 'yes' ? true : false}">--}%
%{--<g:remoteLink controller="import" action="importLocalFiles"--}%
%{--update="centralArea"--}%
%{--title="Import local files">--}%
%{--Import local files--}%
%{--</g:remoteLink>--}%
%{--<h3 class="">--}%
%{--<a>--}%
%{--Import--}%
%{--</a>--}%
%{--</h3>--}%
%{--<div>--}%
%{--<li>--}%
%{--<g:remoteLink controller="import" action="uploadFiles"--}%
%{--update="centralArea"--}%
%{--title="Upload files">--}%
%{--Upload files--}%
%{--</g:remoteLink>--}%
%{--</li>--}%
%{--<li>--}%

%{----}%
%{--</li>--}%
%{--</div>--}%
%{--</g:if>--}%

</div>


<script type="text/javascript">




    var accordion = jQuery("#accordionAdd");
    accordion.accordion({
        header: "h3",
        event: "click",
        active: 0,
        collapsible: true, fillSpace: false, autoHeight: false,
        icons: {
            header: "ui-icon-circle-arrow-e",
            headerSelected: "ui-icon-circle-arrow-s"
        }
    });

</script>