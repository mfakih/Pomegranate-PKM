<%@ page import="ker.OperationController; mcs.Course; mcs.Department; org.apache.commons.lang.StringUtils; cmn.Setting" %>

<h4 class="accordionHeader" onclick="toggleAdd('#accordionAdd', 'addPanel')">Data entry & import</h4>


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

<g:if test="${OperationController.getPath('import.enabled')?.toLowerCase() == 'yes' ? true : false}">
<h3 class="">
    <a>
        Import
    </a>
</h3>
<div>
    <li>
        <g:remoteLink controller="import" action="uploadFiles"
                      update="centralArea"
                      title="Upload files">
            Upload files
        </g:remoteLink>
    </li>
    <li>

        <g:remoteLink controller="import" action="importLocalFiles"
                      update="centralArea"
                      title="Import local files">
            Import local files
        </g:remoteLink>
    </li>
</div>
    </g:if>

<sec:ifAnyGranted roles="ROLE_ADMIN">
    <h3 class="">

        <a>Administration</a>
    </h3>

    <div>
        <ul>
        <li>Configuration

            <ul style="list-style: square">

<g:each in="${[
        ['app.Tag', 'Tag'],
        ['cmn.Setting', 'Setting'],
        ['mcs.parameters.SavedSearch', 'Saved search'],
        ['app.parameters.CommandPrefix', 'Command prefix']
]}" var="i">

    <li>
        <g:remoteLink controller="generics" action="getAddForm"
                          params="[entityController: i[0], isParameter: true,
                                  updateRegion: 'centralArea']"
                          update="centralArea">

                    <span style="font-size: 12px; padding: 2px;">
                        ${i[1]} (${grailsApplication.classLoader.loadClass(i[0]).count()})
                    </span>

            </g:remoteLink>
    </li>
</g:each>
    </ul>
        </li>

            <li>Manage parameters

                <ul style="list-style: square">

                    <g:each in="${[
                            ['app.parameters.Blog', 'Blog'],
                            ['app.parameters.Markup', 'Markup'],
                            ['app.parameters.Pomegranate', 'Pomegranate'],
                            ['mcs.parameters.WorkStatus', 'Work status'],
                            ['mcs.parameters.WritingStatus', 'Writing status'],
                            ['mcs.parameters.ResourceStatus', 'Resource status'],
                            ['app.parameters.ResourceType', 'Resource type'],

                            ['mcs.parameters.Location', 'Location'],
                            ['mcs.parameters.Context', 'Context'],

                            ['mcs.parameters.GoalType', 'Goal type'],
                            ['mcs.parameters.PlannerType', 'Planner type'],
                            ['mcs.parameters.JournalType', 'Journal type'],
                            ['mcs.parameters.WritingType', 'Writing type'],




                            ['mcs.Department', 'Department'],
                            ['mcs.Course', 'Course'],


                            ['app.Indicator', 'Indicator'],
                            ['app.PaymentCategory', 'Payment category'],
                            ['mcs.parameters.RelationshipType', 'Relationship type']

                    ]}"
                            var="i">

                        <g:remoteLink controller="generics" action="getAddForm"
                                      params="[entityController: i[0], isParameter: true,
                                              updateRegion: 'centralArea']"
                                      update="centralArea">
                            <li>
                                <span style="font-size: 12px; padding: 2px;">
                                    ${i[1]} (${grailsApplication.classLoader.loadClass(i[0]).count()})
                                </span>
                            </li>
                        </g:remoteLink>

                    </g:each>
                </ul>

            </li>

<li>
            <g:remoteLink controller="generics" action="logicallyDeletedRecords"
                          update="centralArea"
                          title="Logically deleted records">
                Trash bin
            </g:remoteLink>
</li>
            <li>
                <g:remoteLink controller="report" action="parametersList" update="centralArea">
                    Dashboard
                        %{--todo?--}%
                </g:remoteLink>
            </li>





            <li>

                <g:remoteLink controller="generics" action="updateTagCount" update="notificationArea">
                    Update tag count (todo quartz)
                </g:remoteLink>
            </li>
            <li>

                <g:remoteLink controller="generics" action="dotTextDump" update="notificationArea">
                    Export records to plain text files (in todo)
                </g:remoteLink>

            </li>

            <g:render template="/layouts/savedSearches" model="[entity: 'A']"/>
    </ul>
    </div>

 </sec:ifAnyGranted>

</div>


<g:if test="${OperationController.getPath('coursesPanel.enabled')?.toLowerCase() == 'yes' ? true : false}">
<h4 class="accordionHeader" onclick="toggleAdd('#accordionCourses', 'coursesPanel')">Projects & Courses</h4>
<div id="accordionCourses"
     style="width: 200px; padding: 3px;">


    <g:if  test="${mcs.Department.count() == 0}">
        <h1>There are no departments yet.</h1>
    </g:if>


    <g:each in="${mcs.Department.list([sort: 'code'])}" var="d">

        <h3 class="bowseTab">
                %{--<g:remoteLink controller="report" action="departmentCourses"--}%
                %{--update="centralArea" params="[id: d.id]"--}%
                %{--title="Actions">--}%
                %{--<span style="padding: 1px;">--}%



            <a>

                ${d.summary}
            <span class="moduleCount">

           <b> ${d.code}  </b> (${d.courses.size()})
            </span>
            %{--<span class="I-bkg" style=" float: right;"--}%
                  %{--style="font-family: 'Lucida Console'; margin-right: 3px; padding-right: 2px; font-weight: bold;">--}%
            %{--</span>--}%

            </a>

        </h3>


        <div>
            <ul style="padding-left: 0">
                <g:each in="${Course.findAllByDepartment(Department.get(d.id), [sort: 'code', order: 'asc'])}"
                        var="t">
                    <li style="list-style-type: none">
                        <g:remoteLink controller="generics" action="recordsByCourse" id="${t.id}"
                                   update="centralArea">
                        <b>${t.numberCode}</b>
                            ${StringUtils.abbreviate(t.summary, 26)}
                            <sup>
                                <b>${t.code != t.numberCode.toString() ? t.code : ''}</b>

                            </sup>
                        </g:remoteLink>
                    </li>
                </g:each>
            </ul>
        </div>

    </g:each>

</div>
 </g:if>


<script type="text/javascript">


    var accordion = jQuery("#accordionCourses");
    accordion.accordion({
        header: "h3",
        event: "click",
        active: true,
        collapsible: true, fillSpace: false, autoHeight: false,
        icons: {
            header: "ui-icon-circle-arrow-e",
            headerSelected: "ui-icon-circle-arrow-s"
        }
    });

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