<%@ page import="ker.OperationController; mcs.parameters.JournalType; mcs.parameters.PlannerType; mcs.Book; mcs.Writing; app.Payment; app.IndicatorData; mcs.Journal; cmn.Setting; mcs.Planner; mcs.Task; mcs.Goal; app.Tag" %>



<div id="accordionWest" class="basic" style="height: 100%;">


    <g:if test="${OperationController.getPath('rangeCalendar.enabled')?.toLowerCase() == 'yes' ? true : false}">
    %{--<div class="accordionHeader" onclick="toggleAdd('#dateRange1', 'calendarPanel')">Calendar</div>--}%



    <h4><a href="#">Calendar</a></h4>
    <div id="dateRange1" style="">
        <input type="hidden" class="startDate" id="range_start">
        <input type="hidden" class="endDate" id="range_end">

         <br/>
         <br/>
         <br/>
        Calendar report includes:
        <br/>
     <g:each in="['JP', 'Jtrk', 'Qtrans', 'Qacc', 'log']" var="type">
         <g:remoteLink controller="report" action="setJPReportType" id="${type}"
                       update="${type}ResultSpan"
                       ttypele="Toggle ${type}">
             <span id="${type}ResultSpan" style="font-weight: ${session[type] == 1 ? 'bold': 'normal'}">
                 ${type}
             </span>
         </g:remoteLink>
     </g:each>
        </div>

    </g:if>
    <h4><a href="#">Search</a></h4>
    <div id='searchPanel'>

        <g:formRemote name="genericSearch" url="[controller: 'generics', action: 'hqlSearch']"
                      update="centralArea" method="post" style="display: inline;" onComplete="">

            Search for    <g:select name="resultType"
                                    from="${
                                        [
                                                [enabled: OperationController.getPath('goals.enabled')?.toLowerCase() == 'yes', code: 'G', name: 'Goals'],
                                                [enabled: OperationController.getPath('tasks.enabled')?.toLowerCase() == 'yes', code: 'T', name: 'Tasks'],
                                                [enabled: OperationController.getPath('planner.enabled')?.toLowerCase() == 'yes', code: 'P', name: 'Planner'],
                                                [enabled: OperationController.getPath('journal.enabled')?.toLowerCase() == 'yes', code: 'J', name: 'Journal'],
                                                [enabled: OperationController.getPath('writings.enabled')?.toLowerCase() == 'yes', code: 'W', name: 'Writing'],
                                                [enabled: OperationController.getPath('notes.enabled')?.toLowerCase() == 'yes', code: 'N', name: 'Notes'],
                                                [enabled: OperationController.getPath('resources.enabled')?.toLowerCase() == 'yes', code: 'R', name: 'Resources']

                                        ].grep { it.enabled == true }
                                    }" optionKey="code" optionValue="name"
                                    style="direction: ltr; text-align: left; width: 185px !important"
                                    noSelection="${['null': 'Choose type']}"
                                    onchange="jQuery('#searchForm').load('generics/hqlSearchForm/' + this.value);"
                                    value=""/>


            <br/>

            <div id="searchForm">

            </div>

            <br/>
            Group by:
            <g:select name="groupBy" noSelection="${['null': 'No grouping']}"
                      from="${['department', 'course', 'priority', 'location', 'status', 'type']}"/>
            <br/>
            Sort by:
            <g:select name="sortBy"
                      from="${['id', 'summary', 'status', 'department', 'course', 'type', 'orderNumber', 'dateCreated', 'lastUpdated']}"/>
            <br/>
            Order:
            <g:select name="order"
                      from="${['Asc', 'Desc']}"/>
            <br/>
            Max:
            <g:select name="max" value="3"
                      from="${['1', '3', '5', '10', '20', '50', '100', '500']}"/>
            <br/>

            <g:submitButton class="fg-button ui-icon-left ui-widget ui-state-default ui-corner-all" name="submit"
                            value="Search"
                            onsubmit="jQuery('#searchResults').html('')"/>

        </g:formRemote>

    </div>


    <h4><a href="#">Main reports</a></h4>
    <div>

    <ul>
    
        <g:if test="${OperationController.getPath('kanban.enabled')?.toLowerCase() == 'yes' ? true : false}">
    <li>        <g:link controller="page" action="kanbanCrs"
                    class=" fg-button fg-button-icon-left ui-widget ui-state-default ui-corner-all"
                    target="_blank"
                    title="Kanban">
                <span class="ui-icon ui-icon-check"></span>
                Kanban
            </g:link>
        </li>

        </g:if>



    %{--<g:link controller="page" action="kanbanCrs"--}%
    %{--class=" fg-button fg-button-icon-solo ui-widget ui-state-default ui-corner-all"--}%
    %{--target="_blank"--}%
    %{--title="Kanban">--}%
    %{--<span class="ui-icon ui-icon-plusthick"></span>--}%
    %{--</g:link>--}%
    %{--&nbsp;--}%


        <g:if test="${OperationController.getPath('fullCalendar.enabled')?.toLowerCase() == 'yes' ? true : false}">
        <li>    <g:link controller="page" action="calendar"
                    
                    target="_blank"
                    title="Mega calendar">
                <span class="ui-icon ui-icon-calendar"></span> Calendar
            </g:link>

        </li>
        


        </g:if>
        <g:if test="${OperationController.getPath('kpi.enabled')?.toLowerCase() == 'yes' ? true : false}">
        <li>    <g:link controller="page" action="indicators"
                    
                    target="_blank"
                    title="Indicators">
                <span class="ui-icon ui-icon-signal"></span> KPI
            </g:link>
            </li>
            
        </g:if>

<li>
        <g:remoteLink controller="generics" action="recentRecords"
                    
                      update="centralArea" title="Timeline">
            <span class="ui-icon ui-icon-calendar"></span>

            Timeline
        </g:remoteLink>

        </li>
        





<li>
        <g:remoteLink controller="generics" action="showBookmarkedRecords"
                      update="centralArea"
                  
                      title="Bookmarked records">
            <span class="ui-icon ui-icon-star"></span> Bookmarked records
        </g:remoteLink>
</li>

</ul>
       
        <g:render template="/layouts/savedSearches" model="[entity: 'M']"/>
    </div>
    <h4><a href="#">Monitor</a></h4>
    <div>
        <g:render template="/layouts/savedSearches" model="[entity: 'U']"/>
    </div>

    <h4><a href="#">Modules</a></h4>
    <div>
        <g:render template="/layouts/modulesAccordion"/>

    </div>
 <h4><a href="#">Courses</a></h4>
    <div>

        <g:render template="/layouts/coursesAccordion"/>

    </div>


 <h4><a href="#">Administration</a></h4>
    <div>


        <sec:ifAnyGranted roles="ROLE_ADMIN">
            <h3 class="">

                <a>Parameters</a>
            </h3>

            <div>

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
                                          before="jQuery.address.value(jQuery(this).attr('href'));"
                                          update="centralArea">
                                    <span style="font-size: 12px; padding: 2px;">
                                        ${i[1]} (${grailsApplication.classLoader.loadClass(i[0]).count()})
                                    </span>
                                </br/>
                            </g:remoteLink>

                        </g:each>

            </div>
            <h3 class="">

                <a>Administration</a>
            </h3>

            <div>
        %{--<ul>--}%
        %{--<li>Configuration--}%

            %{--<ul style="list-style: square">--}%

                <g:each in="${[
                        ['app.Tag', 'Tag'],
                        ['cmn.Setting', 'Setting'],
                        ['mcs.parameters.SavedSearch', 'Saved search'],
                        ['app.parameters.CommandPrefix', 'Command prefix']
                ]}" var="i">

                    %{--<li>--}%
                        <g:remoteLink controller="generics" action="getAddForm"
                                      params="[entityController: i[0], isParameter: true,
                                              updateRegion: 'centralArea']"
                                      before="jQuery.address.value(jQuery(this).attr('href'));"
                                      update="centralArea">

                            <span style="font-size: 12px; padding: 2px;">
                                ${i[1]} (${grailsApplication.classLoader.loadClass(i[0]).count()})
                            </span>

                        </g:remoteLink>
                    <br/>
                </g:each>

                <g:remoteLink controller="generics" action="logicallyDeletedRecords"
                              update="centralArea"
                              title="Logically deleted records">
                    Trash bin
                </g:remoteLink>
          <br/>
                <g:remoteLink controller="report" action="parametersList" update="centralArea">
                    Dashboard
                %{--todo?--}%
                </g:remoteLink>
            <br/>

                <g:remoteLink controller="generics" action="updateTagCount" update="notificationArea">
                    Update tag count (todo quartz)
                </g:remoteLink>
            <br/>

                <g:remoteLink controller="generics" action="dotTextDump" update="notificationArea">
                    Export records to plain text files (in todo)
                </g:remoteLink>

                <br/>

            <g:render template="/layouts/savedSearches" model="[entity: 'A']"/>
            </div>

        </sec:ifAnyGranted>


    </div>

</div>



%{--<div class="accordionHeader" onclick="toggleAdd('#accordionSearch', 'searchPanel')">Search</div>--}%
%{--<div id="accordionSearch"--}%
     %{--style="width: 200px; padding: 3px;">--}%

%{--<h3 class="browseTab">--}%
    %{--<a>--}%
        %{--<span class="T-bkg"--}%
        %{--style="font-family: 'Lucida Console'; margin-right: 3px; padding-right: 2px; font-weight: bold; font-size: 12px;">?</span>--}%
        %{--Search--}%
    %{--</a>--}%
%{--</h3>--}%

%{--<div>--}%


%{--</div>--}%
%{--<h3 class="browseTab">--}%
    %{--<a>--}%
        %{--Tags--}%
    %{--</a>--}%
%{--</h3>--}%

%{--<div>--}%



%{--</div>--}%
%{--<h3 class="browseTab">--}%
    %{--<a>--}%
        %{--<span class="ui-icon ui-icon-calendar"></span>--}%
              %{--Calendars--}%
    %{--</a>--}%
%{--</h3>--}%

%{--<div>--}%


    %{--<h2>Journal</h2>--}%
    %{--<ul style="line-height: 30px; font-size: 14px;">--}%

    %{--<g:each in="${JournalType.list([sort: 'name'])}" var="type">--}%
    %{--<g:link controller="task" action="calendar" target="_blank" params="[id: type.id, jp: 'J']"--}%
    %{--title="Calendar">--}%
    %{--${type} <sup>${Journal.countByType(type)}</sup>--}%
    %{--</g:link>--}%
    %{--</g:each>--}%

    %{--</ul>--}%

    %{--<h2>Planner</h2>--}%
    %{--<ul style="line-height: 30px; font-size: 14px;">--}%

    %{--<g:each in="${PlannerType.list([sort: 'name'])}" var="type">--}%
    %{--<g:link controller="task" action="calendar" target="_blank" params="[id: type.id, jp: 'P']"--}%
    %{--title="Calendar">--}%
    %{--${type} <sup>${Planner.countByType(type)}</sup>--}%
    %{--</g:link>--}%
    %{--</g:each>--}%

    %{--</ul>--}%


%{--</div>--}%

%{--<h3 class="browseTab">--}%
    %{--<a>--}%
        %{--<span class="ui-icon ui-icon-script"></span>--}%
        %{--Main reports--}%
    %{--</a>--}%
%{--</h3>--}%

%{--<div>--}%
    %{--<ul>--}%
        %{----}%

    %{--</ul>--}%
%{--</div>--}%

%{--<h3 class="browseTab">--}%
    %{--<a>--}%
        %{--<span class="ui-icon ui-icon-script"></span>--}%
        %{--Records to update--}%
    %{--</a>--}%
%{--</h3>--}%
%{--<div>--}%
    %{--<ul>--}%
        %{--<g:render template="/layouts/savedSearches" model="[entity: 'U']"/>--}%
    %{--</ul>--}%
%{--</div>--}%


%{--</div>--}%

%{--<div class="accordionHeader" onclick="toggleAdd('#accordionModules', 'modulesPanel')">Modules</div>--}%


%{--<g:if test="${ker.OperationController.getPath('twoPanels') == 'off' || ker.OperationController.getPath('twoPanels') == null}">--}%


    %{--<g:render template="/layouts/east"/>--}%
   %{--</g:if>--}%

<script type="text/javascript">

//    var accordion = jQuery("#accordionSearch");
//    accordion.accordion({
//        header: "h3",
//        event: "click",
//        active: false,
//        collapsible: true, fillSpace: false, autoHeight: false,
//        icons: {
//            header: "ui-icon-circle-arrow-e",
//            headerSelected: "ui-icon-circle-arrow-s"
//        }
//    });


 /*
    var accordion = jQuery("#accordionModules");
    accordion.accordion({
        header: "h5",
        event: "click",
        active: false,
        collapsible: true,
        icons: {
            header: "ui-icon-circle-arrow-e",
            headerSelected: "ui-icon-circle-arrow-s"
        }
    });


    var accordion = jQuery("#accordionCourses");
    accordion.accordion({
        header: "h5",
        event: "click",
        active: true,
        collapsible: true,
        icons: {
            header: "ui-icon-circle-arrow-e",
            headerSelected: "ui-icon-circle-arrow-s"
        }
    });

    */
  /*
    var addPanel = true
    var modulesPanel = true
    var coursesPanel = true
    var calendarPanel = true
    var searchPanel = true

    function toggleAdd(panel, varb) {
//        console.log(' pane' + panel + ' var ' + varb)
        if (window[varb] == true) {
            jQuery(panel).addClass('navHidden');
            window[varb] = false
        }
        else if (window[varb] == false) {
            jQuery('#accordionAdd').addClass('navHidden')
            jQuery('#accordionModules').addClass('navHidden')
            jQuery('#accordionCourses').addClass('navHidden')
            jQuery('#dateRange1').addClass('navHidden')
            jQuery('#accordionSearch').addClass('navHidden')
            window['addPanel'] = false
            window['modulesPanel'] = false
            window['coursesPanel'] = false
            window['calendarPanel'] = false
            window['searchPanel'] = false
            jQuery(panel).removeClass('navHidden');
            window[varb] = true
        }
    }


    jQuery('#accordionAdd').addClass('navHidden')
    jQuery('#accordionCourses').addClass('navHidden')
    jQuery('#accordionSearch').addClass('navHidden')
    window['addPanel'] = false
    window['coursesPanel'] = false
    window['searchPanel'] = false
         */
</script>