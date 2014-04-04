<table style="border-collapse: collapse; border: 1px solid gray;" border="1">
    <tr>

        <g:each in="${groups}" var="g">
            <g:if test="${items[groupBy].contains(g)}">
                <td style="vertical-align: top">
                    <h4 style="-moz-column-break-after: column !important;-moz-column-break-before: column !important; padding-left: 0 !important; margin-left: 0 !important">${g.toString()}</h4>
                    <g:findAll in="${items}" expr="${it[groupBy] == g}">
                        <g:render template="/gTemplates/box" model="[record: it]"/>
                    </g:findAll>
                </td>
            </g:if>
        </g:each>

    </tr>
</table>
