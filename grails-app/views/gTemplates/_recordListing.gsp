

<g:if test="${title && !ssId}">
    <h2 style="font-family: Georgia; font-size: 14px; color: #1E71A4; font-weight: bold; line-height: 20px;">
    &sect;    ${title} ${totalHits ? '(' + totalHits + ')' : ''}
    </h2>
%{--<hr/>--}%
</g:if>

<g:if test="${title && ssId}">
       <g:remoteLink controller="generics" action="executeSavedSearch"
                  id="${ssId}"
                  update="centralArea">
      <h2> &sect;  ${title}
      </h2>
    </g:remoteLink>

%{--<hr/>--}%
</g:if>



%{--ToDo fix select all<input type="checkbox" id="selectAll" value="selectAll"> Select / Deselect All<br/><br/>--}%

<g:if test="${ssId && searchResultsTotal}">



    <a id="selectAll" class="fg-button fg-button-icon-left ui-widget ui-state-default ui-corner-all"
       title="Edit box">
        <span class="ui-icon ui-icon-arrow-1-s"></span> Select all
    </a>


    &nbsp;
    &nbsp;
    <a id="deselectAll"
       class=" fg-button fg-button-icon-left ui-widget ui-state-default ui-corner-all"
       title="Edit box">
        <span class="ui-icon ui-icon-arrow-1-n"></span> Deselect all
    </a>

    &nbsp;
    &nbsp;
    <g:remoteLink controller="generics" action="deselectAll"
                  update="centralArea"
                  class=" fg-button fg-button-icon-left ui-widget ui-state-default ui-corner-all"
                  before="if(!confirm('Are you sure you want to deselect all selected records from all current and previous listings? Click on Selected records to see your selections')) return false"
                  title="Selected records">
        <span class="ui-icon ui-icon-arrow-1-n"></span> Clear all selections
    </g:remoteLink>
    <br/>
    <br/>

    <div class="paginateButtons" style="display:inline !important;">
        <util:remotePaginate controller="generics" action="executeSavedSearch" total="${searchResultsTotal}"
                             params="[id: ssId]" update="centralArea"/>
    </div>
    <br/>
</g:if>



<g:elseif test="${searchResultsTotal}">


    <a id="selectAll" class="fg-button fg-button-icon-left ui-widget ui-state-default ui-corner-all"
       title="Edit box">
        <span class="ui-icon ui-icon-arrow-1-s"></span> Select all
    </a>


    &nbsp;
    &nbsp;
    <a id="deselectAll"
       class=" fg-button fg-button-icon-left ui-widget ui-state-default ui-corner-all"
       title="Edit box">
        <span class="ui-icon ui-icon-arrow-1-n"></span> Deselect all
    </a>

    &nbsp;
    &nbsp;
    <g:remoteLink controller="generics" action="deselectAll"
                  update="centralArea"
                  class=" fg-button fg-button-icon-left ui-widget ui-state-default ui-corner-all"
                  before="if(!confirm('Are you sure you want to deselect all selected records from all current and previous listings? Click on Selected records to see your selections')) return false"
                  title="Selected records">
        <span class="ui-icon ui-icon-arrow-1-n"></span> Clear all selections
    </g:remoteLink>
    <br/>
    <br/>

    <div class="paginateButtons" style="display:inline !important;">
        <util:remotePaginate controller="generics" action="hqlSearch" total="${searchResultsTotal}"
                             update="centralArea"/>
    </div>
    <br/>
</g:elseif>





%{--<g:if test="${!list}">--}%
%{--<i>No record.</i>--}%
%{--</g:if>--}%
<g:each in="${list}" status="i" var="record">
    <g:render template="/gTemplates/recordSummary" model="[record: record,
            context: (highlights && highlights[i] ? highlights[i] : null)]"/>
</g:each>

<g:if test="${ssId && searchResultsTotal}">

    <br/>
    <br/> <div class="paginateButtons" style="display:inline !important;">
        <util:remotePaginate controller="generics" action="executeSavedSearch" total="${searchResultsTotal}"
                             params="[id: ssId]" update="centralArea"/>
    </div>
    <br/>
</g:if>



<g:elseif test="${searchResultsTotal}">
    <br/>
    <br/>  <div class="paginateButtons" style="display:inline !important;">
        <util:remotePaginate controller="generics" action="hqlSearch" total="${searchResultsTotal}"
                             update="centralArea"/>
    </div>
    <br/>
</g:elseif>



<sec:ifLoggedIn>
    <sec:ifAnyGranted roles="ROLE_ADMIN">
        <g:if test="${params.action == 'logicallyDeletedRecords'}">
            <g:remoteLink controller="generics" action="physicallyDeleteRecords"
                          update="centralArea"
                          before="if(!confirm('Are you sure you want to delete all records?')) return false"
                          title="Delete all logically deleted records">
                <b style="color: red">Empty trash</b>
            </g:remoteLink>
        </g:if>
    </sec:ifAnyGranted>
</sec:ifLoggedIn>





<script type="text/javascript">
    //   $('#selectAll').click(function() {
    //        if (this.checked) {
    //            $(':checkbox').each(function() {
    //                this.checked = true;
    //            });
    //        } else {
    //            $(':checkbox').each(function() {
    //                this.checked = false;
    //            });
    //        }
    //    });


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

//    });

</script>
