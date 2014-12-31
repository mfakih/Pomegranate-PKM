<%@ page import="app.parameters.CommandPrefix" %>


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



</div>
