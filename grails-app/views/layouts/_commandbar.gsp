<%@ page import="app.Tag; app.parameters.CommandPrefix" %>


<a style="font-size: smaller; color: gray; float: right;" onclick="jQuery('#commandBars').removeClass('navHidden')">Show&nbsp; </a>

<div id="commandBars">
    <a onclick="jQuery('#commandBars').addClass('navHidden')" style="font-size: smaller; color: gray; float: right;">Hide &nbsp;</a>
    <div id="top"></div>

    <g:formRemote name="batchAdd2"
                  url="[controller: 'generics', action: 'batchAddPreprocessor']"
                  update="centralArea"

                  onComplete="var cdate = 'pkm-' + new Date().toISOString(); jQuery('#quickAddTextField').select();localStorage[cdate] = jQuery('#quickAddTextField').val(); document.getElementById('commandHistory').options.add(new Option(localStorage[cdate], cdate));"
                  method="post">

        <g:hiddenField name="sth2" value="${new java.util.Date()}"/>
        <table style="width: 98%; padding: 0px; margin: 0px;">
        <tr>
            <td style=" padding: 0px; margin: 0px; width: 60%">
              Choose action:
                <g:select name="commandPrefix"
                          from="${CommandPrefix.list()}" optionKey="id" optionValue="summary"
                          style="direction: ltr; text-align: left; display: inline; width: 160px;"
                          onchange="jQuery.getJSON('/pkm/generics/commandNotes?q=' + this.value, function(jsdata){jQuery('#quickAddTextField').val(jsdata.info);if (jsdata.info  == null ||  jsdata.info  == 'null' || !jsdata.info) jQuery('#quickAddTextField').addClass('commandMode'); else  jQuery('#quickAddTextField').removeClass('commandMode') })"
                          value=""/>

                </td>
        <td>

            History <select id="commandHistory" style="width: 50px;" onchange="jQuery('#quickAddTextField').val(this.options[this.selectedIndex].text)">
            <option></option>
            </select>
            <g:submitButton name="batch" value="Execute"
                            style="height: 20px; margin: 0px; width: 80px !important;"
                            id="quickAddXcdSubmit"
                            class="fg-button ui-widget ui-state-default"/>

        </td>
        </tr>
        <tr>
        <td colspan="2">
                %{--(Add, update, search, assign records...) Type ? for more info--}%
                <g:textArea cols="80" rows="5" name="block" id="quickAddTextField" value=""
                            autocomplete="off"
                            dir="auto"
                            placeholder="Command bar"
                            onkeyup="if (jQuery('#quickAddTextField').val().search(';')== -1){jQuery('#hintArea').load('${createLink(controller: 'generics', action: 'commandBarAutocomplete')}?hint=1&q=' + encodeURIComponent(jQuery('#quickAddTextField').val()))}"
                            onfocus="jQuery('#hintArea').load('${createLink(controller: 'generics', action: 'commandBarAutocomplete')}?hint=1&q=' + encodeURIComponent(jQuery('#quickAddTextField').val()))"
                            onblur="jQuery('#hintArea').html('')"
                            class="commandBarTexField"/>

            </td>
            %{--<td style="width: 25px !important ; padding: 0px; margin: 0px;">--}%

          </tr>
            %{--</td>--}%
        </table>

    </g:formRemote>



<g:formRemote name="addXcdFormNgs"
              url="[controller: 'indexCard', action: 'addXcdFormNgs']"
              update="centralArea"
              method="post">

    <table style="border: 0; width: 99%">
        <tr>
    <td colspan="2">
        <g:textField placeholder="Summary" name="summary" id="summary" value="" style="width: 95%;" dir="auto"/>

    </td>
            <td>
                <pkm:datePicker name="writtenOn" placeholder="Date" id="34563453" value="${new Date()}"/>
                <g:checkBox name="approximateDate" id="approximateDate" value=""/> ~ ?
            </td>
        </tr>

        <tr>
            <td colspan="2" style="width: 66% !important;">
                <g:textArea cols="80" rows="5" placeholder="Description" name="description" id="description"
                            value="" dir="auto"
                            style="width: 95%; height: 80px;"/>

            </td>
            <td>
            %{--<g:textField placeholder="link" name="link" value="" style="width: 150px;"/>--}%
            %{--<br/>--}%
            <g:select name="chosenTags" from="${Tag.list()}" multiple="" size="80" style="min-width: 200px; min-height: 50px;"
                      value="" optionKey="id"  class="chosen chosen-rtl" id="chosenTags"
                      optionValue="name"
                      noSelection="${['null': '']}"/>
        </td>

        </tr>

    </table>

    <g:submitButton name="save" value="Save"
                    style="height: 20px; margin: 0px; width: 80px !important;"
                    id="45634523"
                    class="fg-button ui-widget ui-state-default"/>


</g:formRemote>
</div>



<script type="text/javascript">
    jQuery("#chosenTags").chosen({allow_single_deselect: true,  no_results_text: "None found", width: 200})

    jQuery('#commandBars').addClass('navHidden')
</script>
