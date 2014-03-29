<%@ page import="java.text.DecimalFormat; cmn.Setting; grails.util.Metadata" %>

<ul id="rssList">

    <li>
        <g:remoteLink controller="report" action="whereIsMyData"
                      update="centralArea"
                      title="Data entry activities">

            Where is my data?
        </g:remoteLink>



    </li>

    <li>
        <g:remoteLink controller="report" action="heartbeat"
                      update="centralArea"
                      title="Data entry activities">
            Heartbeat
        </g:remoteLink>

    </li>
 <li>
        <g:remoteLink controller="report" action="taskCompletionTrack"
                      update="centralArea"
                      title="Task progress track">
            Task track
        </g:remoteLink>

    </li>

    <li>
        <g:remoteLink controller="operation" action="editBoxShow"
                      update="centralArea"
                      title="Edit box">
            Edit box
        </g:remoteLink>

    </li>

    <li>
        <g:remoteLink controller="export" action="rss"
                      update="centralArea"
                      title="RSS feeds">
           RSS
        </g:remoteLink>

    </li>

 <li>
        <g:remoteLink controller="page" action="colors"
                      update="centralArea"
                      title="List of colors to choose from">

            Color picker
        </g:remoteLink>



    </li>

    <li>

        <g:remoteLink controller="generics" action="showSelectedRecords"
                      update="centralArea"
                      title="Selected records">
Selected
        </g:remoteLink>

    </li>

    <li>

        <a id="selectAll"
           title="Select all shown records">
            all
        </a>


        &nbsp;
        &nbsp;
        <a id="deselectAll"
           title="Deselect all shown records">
            none
        </a>

    &nbsp;
    &nbsp;
        <g:remoteLink controller="generics" action="deselectAll"
                      update="centralArea"
                      before="if(!confirm('Are you sure you want to deselect all selected records from all current and previous listings? Click on Selected records to see your selections')) return false"
                      title="Clear all current and past selections">
            clear
        </g:remoteLink>


    </li>






    <sec:ifLoggedIn>
    <sec:ifAnyGranted roles="ROLE_ADMIN">
        <li>
            <a href="${createLink(controller: 'console')}" target="_blank">
                Console
            </a>
        </li>
    </sec:ifAnyGranted>
    </sec:ifLoggedIn>


    %{--<li><pkm:checkFolder folder="wrt" name='wrt.path' path="${OperationController.getPath('privateMode')}"/></li>--}%
    %{--<li><pkm:checkFolder folder="dbt" name='export.recordsToText.path' path="${OperationController.getPath('export.recordsToText.path')}"/></li>--}%
    %{--<li><pkm:checkFolder folder="log" name='log.path' path="${OperationController.getPath('privateMode')}"/></li>--}%
    %{--<li><pkm:checkFolder folder="tmp" name='tmp.path' path="${OperationController.getPath('tmp.path')}"/></li>--}%
    %{--<li><pkm:checkFolder folder="new" name='attachments.sandbox.path' path="${OperationController.getPath('attachments.sandbox.path')}"/></li>--}%
    %{--<li><pkm:checkFolder folder="cvr_ebk" name='covers.sandbox.path'--}%
                          %{--path="${OperationController.getPath('covers.sandbox.path')}"/></li>--}%
    %{--<li><pkm:checkFolder folder="vsn" name='video.snapshots.sandbox.path' path="${OperationController.getPath('video.snapshots.sandbox.path')}"/></li>--}%
    %{--<li><pkm:checkFolder folder="vxr" name='video.excerpts.sandbox.path' path="${'video.excerpts.sandbox.path'}"/></li>--}%
    %{--<li><pkm:checkFolder folder="config" name='confiFile'--}%
                          %{--path="${System.getProperty("user.home")}/.pomegranate.properties"/></li>--}%



%{--<g:if test="${Setting.findByName('privateMode') && OperationController.getPath('privateMode') == 'on'}">--}%
    %{--<li style="color: darkgreen">Private mode</li>--}%
    %{--</g:if>--}%

    <li>
        %{--<g:if test="${environment == 'dev'}">--}%
         %{--DB:   ${org.codehaus.groovy.grails.commons.ConfigurationHolder.config.dataSource.url.split('/').last()}--}%
        %{--</g:if>--}%
        %{--<g:else>--}%
            %{--Prod db--}%
        %{--</g:else>--}%
    </li>

    %{--<li>--}%
        %{--<g:if test="${Setting.findByName('countup.date.days')}">--}%
        %{--<span>--}%
            %{--${new Date() - Date.parse('dd.MM.yyyy', OperationController.getPath('countup.date.days'))} days--}%
        %{--</span>--}%
        %{--</g:if>--}%
%{----}%
%{--</li>--}%
            %{--<g:if test="${Setting.findByName('countup.date.years')}">--}%
                %{--<span>  ${new DecimalFormat('##.##').format((new Date() - Date.parse('dd.MM.yyyy', OperationController.getPath('countup.date.years'))) / 365.25)} years--}%
        %{--</span>--}%


        %{--</g:if>--}%


    <li>

        <g:remoteLink controller="report" action="showLine1Only"
                      update="logArea"
                      title="Selected records">
            Show line 1 only
        </g:remoteLink>


    </li>
  <li>

        <g:remoteLink controller="report" action="showFullCard"
                      update="logArea"
                      title="Selected records">
            Show full card
        </g:remoteLink>


    </li>



</ul>

<div id="notificationArea"></div>


%{--<div id="dialog" title="Basic dialog">--}%
    %{--<p>This is the default dialog which is useful for displaying information. The dialog window can be moved, resized and closed with the 'x' icon.</p>--}%
%{--</div>--}%

<script>
//    $("#dialog").dialog();
</script>