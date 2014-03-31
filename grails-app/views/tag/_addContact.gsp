<h4>Add contact</h4>
<g:formRemote name="addContact" url="[controller: 'generics', action: 'addContactToRecord']"
              onComplete="jQuery('#newContactField${entity}${instance.id}').val('')" update="contacts${entity}${instance.id}"
              style="display: inline;">
    <g:hiddenField name="id" value="${instance.id}"/>
    <g:hiddenField name="entityCode" value="${entity}"/>
    <g:textField id="newContactField${entity}${instance.id}" name="contact" placeholder="Contact..."
                 style="width:100px; display: inline; " value=""/>
    <g:submitButton name="add" value="add" style="display:none;"
                    class="fg-button  ui-widget ui-state-default ui-corner-all"/>
</g:formRemote>

<script type="text/javascript">
    %{--jQuery("#newContactField${entity}${instance.id}").autocomplete('${request.contextPath}/operation/autoCompleteContacts', {--}%
//        mustMatch:false, minChars:0, highlight:false, autoFill:false,
//        delay:10, matchSubset:0, matchContains:1, selectFirst:false,
//        cacheLength:100, multiple:false
//    });
</script>