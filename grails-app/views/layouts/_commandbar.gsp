<%@ page import="app.parameters.CommandPrefix" %>
<div id="commandBars">

    <div id="top"></div>

    <g:formRemote name="batchAdd2"
                  url="[controller: 'generics', action: 'batchAddPreprocessor']"
                  update="centralArea"

                  onComplete="jQuery('#quickAddXcdField').val('')"
                  method="post">

        <g:hiddenField name="sth2" value="${new java.util.Date()}"/>
        <table style="width: 98%; padding: 0px; margin: 0px;">
            <td style=" padding: 0px; margin: 0px; width: 72%">
              Choose action:
                <g:select name="commandPrefix"
                          from="${CommandPrefix.list()}" optionKey="id" optionValue="summary"
                          style="direction: ltr; text-align: left; display: inline; width: 150px;"
                          onchange="jQuery.getJSON('/pkm/generics/commandNotes?q=' + this.value, function(jsdata){jQuery('#quickAddTextField').val(jsdata.info);if (jsdata.info  == null ||  jsdata.info  == 'null' || !jsdata.info) jQuery('#quickAddTextField').addClass('commandMode'); else  jQuery('#quickAddTextField').removeClass('commandMode') })"
                          value=""/>

                </td>
        <td>
            <g:submitButton name="batch" value="Execute"
                            style="height: 20px; margin: 0px; width: 15%;"
                            id="quickAddXcdSubmit"
                            class="fg-button ui-widget ui-state-default"/>

        </td>
        </tr>
        <tr>
        <td colspan="2">
                %{--(Add, update, search, assign records...) Type ? for more info--}%
                <g:textArea cols="80" rows="5" name="block" id="quickAddTextField" value=""
                            autocomplete="off"
                            placeholder="Command bar"
                            onkeyup="if (jQuery('#quickAddTextField').val().search(';')== -1){jQuery('#hintArea').load('${createLink(controller: 'generics', action: 'commandBarAutocomplete')}?hint=1&q=' + encodeURIComponent(jQuery('#quickAddTextField').val()))}"
                            onfocus="jQuery('#hintArea').load('${createLink(controller: 'generics', action: 'commandBarAutocomplete')}?hint=1&q=' + encodeURIComponent(jQuery('#quickAddTextField').val()))"
                            onblur="jQuery('#hintArea').html('')"
                            class="commandBarTexField"/>

            </td>
            %{--<td style="width: 25px !important ; padding: 0px; margin: 0px;">--}%


            %{--</td>--}%
        </table>

    </g:formRemote>



</div>
