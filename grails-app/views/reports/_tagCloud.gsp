<%@ page import="app.Tag" %>
<div style="-moz-column-count: 4">
    <ul>
<g:each in="${Tag.list([sort: 'name', order: 'asc'])}" var="t">
    <li style="list-style-type: circle; font-size: ${13 + (t.occurrence ? Math.ceil(Math.log(t.occurrence)) : 0)}px; line-height: 18px;">
        <g:remoteLink controller="generics" action="tagReport" id="${t.id}"
                      update="centralArea">
        ${t.name} <sup><i>${t.occurrence}</i></sup>
    </g:remoteLink>
    </li>
</g:each>
    </ul>
</div>
