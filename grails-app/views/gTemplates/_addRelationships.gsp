<g:formRemote name="addRelationship" url="[controller: 'generics', action: 'addRelationship']"
              onComplete="jQuery('#newRelationshipField${entity}${record.id}').val('')"
              update="relationshipRegion${entity}${record.id}"
              style="display: inline;">
    <g:hiddenField name="id" value="${record.id}"/>
    <g:hiddenField name="entityCode" value="${entity}"/>
    <g:select name="type" style="width: 80px;"
              from="${mcs.parameters.RelationshipType.list()}" optionKey="id" optionValue="name"/>

    <g:textField id="newRelationshipField${entity}${record.id}" name="recordB" class="ui-corner-all"
                 title="[type][id] ([type] [summary] for autocomplete)" placeholder="[type] [summary] to start autocomplete"
                 style="width:140px; display: inline; " value=""/>
    <g:submitButton name="add" value="add" style="display:none;"
                    class="fg-button  ui-widget ui-state-default ui-corner-all"/>
</g:formRemote>

<script type="text/javascript">
    %{--jQuery("#newRelationshipField${entity}${record.id}").find('input').autocomplete("generics/autoCompleteMainEntities", {--}%
        %{--mustMatch: false, minChars: 4, highlight: false, autoFill: false,--}%
        %{--delay: 100, matchSubset: 0, matchContains: 1, selectFirst: false,--}%
%{--//        cacheLength:100,--}%
        %{--multiple: false,--}%
        %{--formatResult: function (data, p, l) {--}%
            %{--return data[1]--}%
        %{--}--}%
    %{--});--}%


    var bestPictures = new Bloodhound({
        datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
        queryTokenizer: Bloodhound.tokenizers.whitespace,
        prefetch: '/pkm/generics/autoCompleteMainEntities?date=${new Date().format('ddMMyyyHHMMss')}',
        remote: '/pkm/generics/autoCompleteMainEntities'
    });

    bestPictures.initialize();

    $('#newRelationshipField${entity}${record.id}').typeahead({
        hint: true,
        highlight: true,
        minLength: 1
    }, {
        name: 'id',
        displayKey: 'value',
        source: bestPictures.ttAdapter()
    });




</script>