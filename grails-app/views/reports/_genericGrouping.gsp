<%@ page import="cmn.Setting" %>
<h2>${title}</h2>
    <div style="-moz-column-count: ${Setting.findByNameLike('grouping-colmns') ? Setting.findByNameLike('grouping-colmns').value.toInteger() : 2}; -webkit-column-count: ${Setting.findByNameLike('grouping-colmns') ? Setting.findByNameLike('grouping-colmns').value.toInteger() : 2}">
<g:each in="${groups}" var="g">
    <g:if test="${items[groupBy].contains(g)}">
        %{--<div >--}%
            %{--<hr/>--}%
        %{--</div>   --}%
        <h4 style="-moz-column-break-after: column !important;-moz-column-break-before: column !important; padding-left: 0 !important; margin-left: 0 !important" >${g.toString()}</h4>


    <g:findAll in="${items}" expr="${it[groupBy] == g}">
        <g:render template="/gTemplates/box" model="[record: it]"/>
    </g:findAll>
                %{--<center>--}%
                    %{--* * *--}%
                %{--</center>--}%
        </g:if>

</g:each>
    </div>
        <br/>
        <br/>
