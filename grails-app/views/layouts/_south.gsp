<%@ page import="java.text.DecimalFormat; cmn.Setting; grails.util.Metadata" %>

<ul id="rssList">

<sec:ifAnyGranted roles="ROLE_ADMIN">
    <li>
        <g:remoteLink controller="report" action="whereIsMyData"
                      update="centralArea"
                      before="jQuery.address.value(jQuery(this).attr('href'));"
                      title="Data entry activities">

            My data
        </g:remoteLink>



    </li>

    <li>
        <g:remoteLink controller="report" action="heartbeat"
                      update="centralArea"
                      before="jQuery.address.value(jQuery(this).attr('href'));"
                      title="Data entry activities">
            Heartbeat
        </g:remoteLink>

    </li>
 <li>
        <g:remoteLink controller="report" action="taskCompletionTrack"
                      update="centralArea"
                      before="jQuery.address.value(jQuery(this).attr('href'));"
                      title="Task progress track">
            Task track
        </g:remoteLink>

    </li>

    <li>
        <g:remoteLink controller="operation" action="editBoxShow"
                      update="centralArea"
                      before="jQuery.address.value(jQuery(this).attr('href'));"
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


    </sec:ifAnyGranted>
    <li>

        <g:remoteLink controller="generics" action="showSelectedRecords"
                      update="centralArea"
                      before="jQuery.address.value(jQuery(this).attr('href'));"
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
                      update="notificationAreaHidden"
                      before="if(!confirm('Are you sure you want to deselect all selected records from all current and previous listings? Click on Selected records to see your selections')) return false"
                      title="Clear all current and past selections">
            clear
        </g:remoteLink>


    </li>

<sec:ifAnyGranted roles="ROLE_ADMIN">
      <li>


          <input type="radio" name="myRadios" onchange="singleDisplay();" value="Single" />
          <input type="radio" name="myRadios" onchange="dualDisplay();" value="dual display" />

          %{--<a id="singleDisplay"--}%
             %{--title="Single display">--}%
              %{--Single--}%

          %{--&nbsp;--}%
          %{--&nbsp;--}%
          %{--<a id="dualDisplay"--}%
             %{--title="Dual display">--}%
              %{--dual display--}%
          %{--</a>--}%
      </li>



        <li>
            <a href="${createLink(controller: 'console')}" target="_blank">
                Console
            </a>
        </li>
    </sec:ifAnyGranted>


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

<sec:ifAnyGranted roles="ROLE_ADMIN">

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

    </sec:ifAnyGranted>

    <li>

      r/p <g:select name="resultType"
                                from="${[3,5,10,15,20,15,50,100]}"
                                style="direction: ltr; text-align: left; padding: 0; margin: 0"
                                noSelection="${['null': '']}"
                                onchange="jQuery('#notificationArea').load('generics/setPageMax/' + this.value);"
                                value="${Setting.findByNameLike('savedSearch.pagination.max.link')?.value ?: 5}"/>



    </li>



</ul>

<div id="notificationArea"></div>
<div style="display: none" id="notificationAreaHidden"></div>


%{--<div id="dialog" title="Basic dialog">--}%
    %{--<p>This is the default dialog which is useful for displaying information. The dialog window can be moved, resized and closed with the 'x' icon.</p>--}%
%{--</div>--}%

<script>
//    $("#dialog").dialog();

function dualDisplay() {
    document.getElementById("centralArea").id = "temp1q";
    document.getElementById("sandboxPanel").id = "centralArea";
    console.log('dual')
    jQuery('#accordionEast').accordion({ active: 4});

}

function singleDisplay() {
    document.getElementById("temp1q").id = "centralArea";
    document.getElementById("centralArea").id = "sandboxPanel";
    console.log('single')
}


$('#selectAll').click(function (e) {
    $("input[name^='select-']").each(function () {
//        this['value'] = 'on'
        this['checked'] = true
//        console.log(this.attr('value'));
        jQuery('#logRegion').load('generics/selectOnly/' + this['name'].split('-')[2] + this['name'].split('-')[1]);
    });
})

$('#deselectAll').click(function (e) {
    $("input[name^='select-']").each(function () {
        this['checked'] = false
//        console.log(this.attr('value'));
        jQuery('#logRegion').load('generics/deselectOnly/' + this['name'].split('-')[2] + this['name'].split('-')[1]);
    });
})
</script>