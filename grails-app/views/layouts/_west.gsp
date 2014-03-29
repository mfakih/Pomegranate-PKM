<%@ page import="ker.OperationController; mcs.parameters.JournalType; mcs.parameters.PlannerType; mcs.Book; mcs.Writing; app.Payment; app.IndicatorData; mcs.Journal; cmn.Setting; mcs.Planner; mcs.Task; mcs.Goal; app.Tag" %>


<g:if test="${OperationController.getPath('rangeCalendar.enabled')?.toLowerCase() == 'yes' ? true : false}">
<div class="accordionHeader" onclick="toggleAdd('#dateRange1', 'calendarPanel')">Calendar</div>
<div id="dateRange1" style="">
    <input type="hidden" class="startDate" id="range_start">
    <input type="hidden" class="endDate" id="range_end">
</div>
</g:if>



<div class="accordionHeader" onclick="toggleAdd('#accordionSearch', 'searchPanel')">Search</div>
<div id="accordionSearch"
     style="width: 200px; padding: 3px;">

<h3 class="browseTab">
    <a>
        %{--<span class="T-bkg"--}%
        %{--style="font-family: 'Lucida Console'; margin-right: 3px; padding-right: 2px; font-weight: bold; font-size: 12px;">?</span>--}%
        Search
    </a>
</h3>

<div>

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
<h3 class="browseTab">
    <a>
        Tags
    </a>
</h3>

<div>

    <div style="-moz-column-count: 2">
        <ul>
            <g:each in="${Tag.list([sort: 'name', order: 'asc'])}" var="t">
                <li style="list-style-type: circle; font-size: ${13 + (t.occurrence ? Math.ceil(Math.log(t.occurrence)) : 0)}px; line-height: 18px;">
                    <g:remoteLink controller="generics" action="tagReport" id="${t.id}"
                                  update="centralArea">
                        ${t.name} <sup><i>${t.occurrence}</i></sup>
                    </g:remoteLink>
                </li>
            </g:each>
        </ul>
    </div>


</div>
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

<h3 class="browseTab">
    <a>
        <span class="ui-icon ui-icon-script"></span>
        Main reports
    </a>
</h3>

<div>
    <ul>
        <g:render template="/layouts/savedSearches" model="[entity: 'M']"/>

    </ul>
</div>

<h3 class="browseTab">
    <a>
        <span class="ui-icon ui-icon-script"></span>
        Records to update
    </a>
</h3>
<div>
    <ul>
        <g:render template="/layouts/savedSearches" model="[entity: 'U']"/>
    </ul>
</div>


</div>

<div class="accordionHeader" onclick="toggleAdd('#accordionModules', 'modulesPanel')">Modules</div>

<div id="accordionModules"
     style="width: 200px; padding: 3px;">

<g:if test="${OperationController.getPath('goals.enabled')?.toLowerCase() == 'yes' ? true : false}">
<h3><a>
    <span class="G-bkg"
          style="font-family: 'Lucida Console'; margin-right: 3px; padding-right: 2px; font-weight: bold;">G</span>
    ${OperationController.getPath('goals.label') ?: 'Goals'} <span
            class="moduleCount">
        ${Goal.count()}
    </span>
</a>
</h3>

<div>
    <ul>
<g:render template="/layouts/savedSearches" model="[entity: 'G']"/>
</ul>
</div>
</g:if>

<g:if test="${OperationController.getPath('tasks.enabled')?.toLowerCase() == 'yes' ? true : false}">

<h3><a>
    <span class="T-bkg"
          style="font-family: 'Lucida Console'; margin-right: 3px; padding-right: 2px; font-weight: bold; font-size: 12px;">T</span>
    ${OperationController.getPath('tasks.label') ?: 'Tasks'}<span
            class="moduleCount">${Task.count()}</span></a></h3>

<div>

    <ul>

        <li>
            <g:link controller="task" action="expotTodotxt" target="_blank">
                Export to Todo.txt format
            </g:link>

        </li>

        <g:render template="/layouts/savedSearches" model="[entity: 'T']"/>
</ul>
</div>
    </g:if>

<g:if test="${OperationController.getPath('planner.enabled')?.toLowerCase() == 'yes' ? true : false}">

    <h3><a>
        <span class="P-bkg"
              style="font-family: 'Lucida Console'; margin-right: 3px; padding-right: 2px; font-weight: bold;">P</span>
        ${OperationController.getPath('planner.label') ?: 'Planner'}<span
                class="moduleCount">${Planner.count()}</span>
    </a>
    </h3>

    <div>

        <ul>

            <g:render template="/layouts/savedSearches" model="[entity: 'P']"/>

        </ul>

    </div>

</g:if>


<g:if test="${OperationController.getPath('journal.enabled')?.toLowerCase() == 'yes' ? true : false}">
    <br/>
<h3><a>
    <span class="J-bkg"
          style="font-family: 'Lucida Console'; margin-right: 3px; padding-right: 2px; font-weight: bold;">J</span>
    ${OperationController.getPath('journal.label') ?: 'Journal'}<span
            class="moduleCount">${Journal.count()}</span>
</a>
</h3>

<div>

    <ul>
        <li>

            <a href="${createLink(controller: 'export', action: 'exportIcal', id: 'journal.ics')}"
            target="_blank">
            Export journal to iCal
            </a>

        </li>
        <g:render template="/layouts/savedSearches" model="[entity: 'J']"/>
    </ul>

</div>

    </g:if>

<g:if test="${OperationController.getPath('indicators.enabled')?.toLowerCase() == 'yes' ? true : false}">
    <h3>

        <a>

            <span class="K-bkg"
                  style="font-family: 'Lucida Console'; margin-right: 3px; padding-right: 2px; font-weight: bold;">I</span>
            ${OperationController.getPath('indicators.label') ?: 'Indicators'}<span
                class="moduleCount">${IndicatorData.count()}</span>
        </a>
    </h3>

    <div>

        <ul>
            <li>
                <g:remoteLink controller="report" action="indicatorPanorama"
                              update="centralArea"
                              title="Update indicators">
                    Update indicators
                </g:remoteLink>


            </li>

            <g:render template="/layouts/savedSearches" model="[entity: 'K']"/>
        </ul>

    </div>
</g:if>


<g:if test="${OperationController.getPath('payments.enabled')?.toLowerCase() == 'yes' ? true : false}">
    <h3><a><span class="Q-bkg"
                 style="font-family:  'Lucida Console'; margin-right: 3px; padding-right: 2px; font-weight: bold;">Q</span>
        ${OperationController.getPath('payments.label') ?: 'Payments'}
        <span
                class="moduleCount">${Payment.count()}</span>
    </a>
    </h3>


    <div>

        <ul>
            <li>
                <a onclick="jQuery('#searchArea').load('report/paymentCategories')">All categories</a>
            </li>

            <g:render template="/layouts/savedSearches" model="[entity: 'Q']"/>

        </ul>

    </div>
</g:if>


<g:if test="${OperationController.getPath('writings.enabled')?.toLowerCase() == 'yes' ? true : false}">
    <br/>
    <h3><a>
        <span class="W-bkg"
              style="font-family: 'Lucida Console'; margin-right: 3px; padding-right: 2px; font-weight: bold;">W</span>
        ${OperationController.getPath('writings.label') ?: 'Writings'}<span
                class="moduleCount">${Writing.count()}</span>
    </a></h3>

    <div>

        <ul>
            <li>

                <a onclick="jQuery('#logArea').load('export/generateForKindle')">
                Generate wrt for kindle (one txt file per course)
                </a>
            </li>



            <li>
                <g:remoteLink controller="export" action="checkoutWritings"
                              update="centralArea"
                              title="Export all writings to text files">
                    Export all writings to text files
                </g:remoteLink>
            %{--todo--}%




            <li>
                <a href="${createLink(controller: 'export', action: 'exportWritingsToOneFile')}"
            target="_blank">Writings 2 html (new page)</a>
            </li>

           <li>
               <g:render template="/layouts/savedSearches" model="[entity: 'W']"/>


        </li>


        </ul>

    </div>
</g:if>

<g:if test="${OperationController.getPath('notes.enabled')?.toLowerCase() == 'yes' ? true : false}">
<h3>
    <a>
        <span class="N-bkg"
              style="font-family: 'Lucida Console'; margin-right: 3px; padding-right: 2px; font-weight: bold;">N</span>
        ${OperationController.getPath('notes.label') ?: 'Notes'}
        <span class="moduleCount">${app.IndexCard.count()}</span>
    </a>
</h3>

<div>
    <ul>
        <g:render template="/layouts/savedSearches" model="[entity: 'N']"/>
    </ul>

</div>
    </g:if>
<br/>

<g:if test="${OperationController.getPath('resources.enabled')?.toLowerCase() == 'yes' ? true : false}">
<h3><a>
    <span class="R-bkg"
          style="font-family: 'Lucida Console'; margin-right: 3px; padding-right: 2px; font-weight: bold;">R</span>
    ${OperationController.getPath('resources.label') ?: 'Resources'}
    <span class="moduleCount">${mcs.Book.executeQuery("select count (*) from Book")[0]}
    </span>
</a></h3>

<div>

    <ul>

        <li><a onclick="jQuery('#centralArea').load('report/duplicateIsbnBooks')">Books with duplication ISBN</a>
        </li>



        <li>
        <a onclick="jQuery('#centralArea').load('export/exportAllBooksByCourseAsLinks')"
        title="generates link.bat">
        Export hard links scripts todo
        </a>
        </li>
        <li>
            <g:remoteLink controller="operation" action="updateAllWithoutTitle" update="notificationArea">
                Update all ISBNs of books without title (${Book.countByIsbnIsNotNullAndTitleIsNull()})
                todo
            </g:remoteLink>

        </li>
   <li>
            <g:remoteLink controller="operation" action="updateAllBibEntries" update="notificationArea">
                Update all BibTex entries (${Book.countByIsbnIsNotNullAndBibEntryIsNull()})
            </g:remoteLink>

        </li>

        <li>
            <a href="export/exportAllBooksToText" target="_blank"
               title="">
                Show books list in text
            </a>
        </li>


    %{--<li><a onclick="jQuery('#centralArea').load('book/report/notitle')">No title books</a>--}%
    %{--</li>--}%

    %{--<li><a onclick="jQuery('#centralArea').load('book/report/isbnNoTitle')">ISBN  without title</a>--}%
    %{--</li>--}%
    <g:render template="/layouts/savedSearches" model="[entity: 'R']"/>
    </ul>

</div>
    </g:if>

<g:if test="${OperationController.getPath('excerpts.enabled')?.toLowerCase() == 'yes' ? true : false}">
    <h3><a>
        <span class="E-bkg"
              style="font-family: 'Lucida Console'; margin-right: 3px; padding-right: 2px; font-weight: bold;">E</span>
        ${OperationController.getPath('excerpts.label') ?: 'Excerpts'} <span class="moduleCount">${mcs.Excerpt.countByDeletedOnIsNull()}
        </span>
    </a>
    </h3>

    <div>
        <ul>
            <g:render template="/layouts/savedSearches" model="[entity: 'E']"/>

        </ul>
    </div>

</g:if>

<g:if test="${OperationController.getPath('contacts.enabled')?.toLowerCase() == 'yes' ? true : false}">
    <h3>
        <a>
            <span class="U-bkg"
                  style="font-family: 'Lucida Console'; margin-right: 3px; padding-right: 2px; font-weight: bold;">U</span>
            ${OperationController.getPath('contacts.label') ?: 'Contacts'}<span
                class="moduleCount">${app.Contact.countByDeletedOnIsNull()}</span>
        </a>
    </h3>

    <div>
        <ul>

            <g:render template="/layouts/savedSearches" model="[entity: 'U']"/>
        </ul>

    </div>
    <br/>
</g:if>

</div>


%{--<g:if test="${ker.OperationController.getPath('twoPanels') == 'off' || ker.OperationController.getPath('twoPanels') == null}">--}%

    <g:render template="/layouts/east"/>
   %{--</g:if>--}%

<script type="text/javascript">

    var accordion = jQuery("#accordionSearch");
    accordion.accordion({
        header: "h3",
        event: "click",
        active: false,
        collapsible: true, fillSpace: false, autoHeight: false,
        icons: {
            header: "ui-icon-circle-arrow-e",
            headerSelected: "ui-icon-circle-arrow-s"
        }
    });

    var accordion = jQuery("#accordionModules");
    accordion.accordion({
        header: "h3",
        event: "click",
        active: false,
        collapsible: true, fillSpace: false, autoHeight: false,
        icons: {
            header: "ui-icon-circle-arrow-e",
            headerSelected: "ui-icon-circle-arrow-s"
        }
    });


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

</script>