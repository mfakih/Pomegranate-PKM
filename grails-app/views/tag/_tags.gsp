<div id="tags${entity}${instance.id}" style="display: inline; float: right;">
    <g:if test="${instance.tags}">
        <g:each in="${instance.tags?.sort(){i,j -> i.name.toLowerCase().compareTo(j.name.toLowerCase())}}" var="t">
            &nbsp;  <div style=" display:inline; padding: 1px; margin-right: 3px; font-size: 11px; border: 1px solid #808080; border-radius: 4px;" class="ui-corner-all">

            <g:if test="${t?.isKeyword == true}">
                <b>${t?.name}</b>
            </g:if>
            <g:else>
                <i>${t?.name}</i>
            </g:else>


            <g:remoteLink controller="generics" action="removeTagFromRecord" id="${instance.id}" update="tags${entity}${instance.id}"
                          params="[tagId: t.id, recordId: instance.id, entityCode: entity]"
                          before="if(!confirm('Are you sure you want to remove the tag from the record? The tag itself will NOT be deleted')) return false"
                          title="remove tag" style="font-size: smaller">x</g:remoteLink>

        </div>
        </g:each>
    </g:if>
</div>