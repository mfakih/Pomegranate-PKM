
    <g:if test="${record.class.declaredFields.name.contains('tags')}">
        <g:render template="/tag/addTag" model="[instance: record, entity: entityCode]"/>
        <g:render template="/tag/addContact" model="[instance: record, entity: entityCode]"/>
    </g:if>
