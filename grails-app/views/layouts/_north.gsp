<%@ page import="ker.OperationController; cmn.Setting;" %>


<div  class="nav nonPrintable"
      style="width: 98%; padding: 3px;">

&nbsp;
    <img src="${resource(dir: 'images', file: 'favicon-32px.png')}" width="15px;"/>

    <g:link controller="page" action="main" target="_blank"
            title="Open app in a new tab">
        <span style="color: #fff;">
        <b style="font-size: 13px; font-family: Trebuchet MS, Verdana, Geneva, Arial, Helvetica, sans-serif;">
            ${OperationController.getPath('app.name') ?: 'Pomegranate PKM'}</b> &nbsp;
        <sup><i>v</i><g:meta name="app.version"/></sup>
        </span>
    </g:link>
<g:if test="${OperationController.getPath('show.textlogo')?.toLowerCase() == 'yes' ? true : false}">
<sub>
    <a href="http://pomegranate-pkm.org" target="_blank">
        <i style="font-size: 10px; color: #ffffff">A Pomegranate PKM system</i>
    </a>
</sub>
      </g:if>

&nbsp;

    <% Calendar c = new GregorianCalendar(); c.setLenient(false); c.setMinimalDaysInFirstWeek(4);
    c.setFirstDayOfWeek(java.util.Calendar.MONDAY)
    %>
    <b>Week ${c.get(Calendar.WEEK_OF_YEAR)}</b>
&nbsp;


&nbsp;
&nbsp;
&nbsp;
<g:if test="${OperationController.getPath('kanban.enabled')?.toLowerCase() == 'yes' ? true : false}">
<g:link controller="page" action="kanbanCrs"
        class=" fg-button fg-button-icon-left ui-widget ui-state-default ui-corner-all"
        target="_blank"
        title="Kanban">
    <span class="ui-icon ui-icon-check"></span>
    Kanban
</g:link>
    </g:if>
&nbsp;


%{--<g:link controller="page" action="kanbanCrs"--}%
%{--class=" fg-button fg-button-icon-solo ui-widget ui-state-default ui-corner-all"--}%
%{--target="_blank"--}%
%{--title="Kanban">--}%
%{--<span class="ui-icon ui-icon-plusthick"></span>--}%
%{--</g:link>--}%
%{--&nbsp;--}%


<g:if test="${OperationController.getPath('fullCalendar.enabled')?.toLowerCase() == 'yes' ? true : false}">
<g:link controller="page" action="calendar"
        class=" fg-button fg-button-icon-left ui-widget ui-state-default ui-corner-all"
        target="_blank"
        title="Mega calendar">
    <span class="ui-icon ui-icon-calendar"></span> Calendar
</g:link>

&nbsp;
    </g:if>
<g:if test="${OperationController.getPath('kpi.enabled')?.toLowerCase() == 'yes' ? true : false}">
<g:link controller="page" action="indicators"
        class=" fg-button fg-button-icon-left ui-widget ui-state-default ui-corner-all"
        target="_blank"
        title="Indicators">
    <span class="ui-icon ui-icon-signal"></span> KPI
</g:link>
    &nbsp;
    </g:if>


    <g:remoteLink controller="generics" action="recentRecords"
                  class=" fg-button fg-button-icon-solo ui-widget ui-state-default ui-corner-all"
                  update="centralArea"
                  title="Timeline">
        Timeline
    </g:remoteLink>

&nbsp;




<g:remoteLink controller="generics" action="showBookmarkedRecords"
              update="centralArea"
              class=" fg-button fg-button-icon-solo ui-widget ui-state-default ui-corner-all"
              title="Bookmarked records">
    <span class="ui-icon ui-icon-star"></span>
</g:remoteLink>
&nbsp;
&nbsp;
&nbsp;






    %{--<g:remoteLink controller="report" action="tagCloud"--}%
                  %{--update="centralArea"--}%
                  %{--class=" fg-button fg-button-icon-left ui-widget ui-state-default ui-corner-all"--}%
                  %{--title="Tag cloud">--}%
        %{--<span class="ui-icon ui-icon-tag"></span> Tags--}%
    %{--</g:remoteLink>--}%
%{--&nbsp;--}%


    %{--<g:remoteLink controller="report" action="rss"--}%
                  %{--update="centralArea"--}%
                  %{--class=" fg-button fg-button-icon-solo ui-widget ui-state-default ui-corner-all"--}%
                  %{--title="Tag cloud">--}%
        %{--<span class="ui-icon ui-icon-signal"></span>--}%
    %{--</g:remoteLink>--}%
%{--&nbsp;--}%





&nbsp;
&nbsp;
&nbsp;


    <sec:ifLoggedIn>
        <sec:ifAnyGranted roles="ROLE_ADMIN">
            <g:link controller='user' >

                <b style="color: #ffffff;"><sec:username/></b>

            </g:link>
        </sec:ifAnyGranted>
        <sec:ifNotGranted roles="ROLE_ADMIN">
            <b style="color: #ffffff;"><sec:username/></b>

        </sec:ifNotGranted>



        <g:link controller='logout' style="color: #ffffff !important;">Logout &nbsp;</g:link>
    </sec:ifLoggedIn>
    <sec:ifNotLoggedIn>
        <a href='#' id='loginLink'>Login</a>
    </sec:ifNotLoggedIn>

&nbsp;
&nbsp;
&nbsp;

    <g:formRemote name="searchField" url="[controller: 'generics', action: 'quickSearch']" update="centralArea"
                  method="post" style="display: inline; "
                  onComplete="">
    %{--<g:textField id="courseTest" class="ui-corner-all" style="width:150px;" name="q"/>--}%
        <g:textField id="searchField" name="q" style="width: 150px; margin: 1px; background: #ffffff"
                     type="text"
                     placeholder="Quick search..."
                     title=""/>
        <g:submitButton class="" style="visibility: hidden;"
                        name="submit" value="s"/>
    </g:formRemote>



</div>
