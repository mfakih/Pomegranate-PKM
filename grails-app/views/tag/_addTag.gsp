<h4>Add tag</h4>
<g:formRemote name="addTag" url="[controller: 'generics', action: 'addTagToRecord']"
              onComplete="jQuery('#newTagField${entity}${instance.id}').val('')" update="tags${entity}${instance.id}"
              style="display: inline;">
    <g:hiddenField name="id" value="${instance.id}"/>
    <g:hiddenField name="entityCode" value="${entity}"/>
    <g:textField id="newTagField${entity}${instance.id}" name="tag"
                 style="width:100px; display: inline; " value=""/>

    <g:submitButton name="add" value="add" style="display:none;"
                    class="fg-button  ui-widget ui-state-default ui-corner-all"/>
</g:formRemote>

<script type="text/javascript">

    %{--jQuery("#newTagField${entity}${instance.id}").autocomplete({appendTo: "body", source: 'operation/autoCompleteTags'})--}%
//        mustMatch:false
//        minChars:0, highlight:false, autoFill:false,
//        delay:10, matchSubset:0, matchContains:1, selectFirst:false,
//        cacheLength:100, multiple:false
//    });
</script>