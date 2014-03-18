<%@ page import="ker.OperationController; cmn.Setting; app.IndexCard; mcs.Writing" %>

Edit folder: ${OperationController.getPath('editBox.path')}
<br/>
<br/>



<br/>
<br/>
<g:remoteLink controller="operation" action="editBoxCheckout"
              update="centralArea"
              class=" fg-button fg-button-icon-left ui-widget ui-state-default ui-corner-all"
              title="Edit box">
    <span class="ui-icon ui-icon-arrow-1-s"></span> Checkout bookmarked records
</g:remoteLink>



&nbsp;
&nbsp;<g:remoteLink controller="operation" action="editBoxCommit"
                    update="centralArea"
                    class=" fg-button fg-button-icon-left ui-widget ui-state-default ui-corner-all"
                    title="Edit box">
    <span class="ui-icon ui-icon-arrow-1-n"></span> Commit changes
</g:remoteLink>

<br/>
<br/>


<table border="1" style="border-collapse: collapse">
    <thead>
    <th>Original (database) contents </th>
    <th>New (file) contents </th>
    </thead>

<g:each in="${OperationController.getFileListing('editBox.path')}" var="f">

    <g:set value="${f.name.split(' ')[0].split('_')}" var="ID"></g:set>

    <g:if test="${f.text != Writing.get(ID[1]).description}">
    <tr>
        <td colspan="2" style="text-align: left; padding: 5px;">
       <b>   ${f.name}</b>
        </td>
    </tr>
    <tr>
        <td style="width: 50%; vertical-align: top">
            ${ID[0] == 'N' ? IndexCard.get(ID[1]).description?.encodeAsHTML()?.replace('\n', '<br/>') : ''}
            ${ID[0] == 'W' ? Writing.get(ID[1]).description?.encodeAsHTML()?.replace('\n', '<br/>') : ''}

        </td>
        <td style="width: 50%; vertical-align: top">
             ${f.text?.encodeAsHTML()?.replace('\n', '<br/>')}
        </td>

    </tr>
        </g:if>
</g:each>
</table>
<br/>
<br/>





<br/>
<h4>Bookmarked records</h4>
<g:render template="/gTemplates/recordListing" model="[list: IndexCard.findAllByBookmarked(true) + Writing.findAllByBookmarked(true)]"></g:render>

