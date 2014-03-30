<%@ page import="app.Tag" %>
<div style="-moz-column-count: 1">
    %{--<ul>--}%
<g:each in="${Tag.list([sort: 'name', order: 'asc'])}" var="t">
    <span style="list-style-type: none; border-right: 0.5px solid #dddddd; margin: 4px; font-size: ${14 + (t.occurrence ? Math.ceil(Math.log(t.occurrence)) : 0)}px; line-height: 25px;">
        <g:remoteLink controller="generics" action="tagReport" id="${t.id}"
                      update="centralArea">
        ${t.name} <span style="font-size: 11px;"><i>${t.occurrence}</i></span>
    </g:remoteLink>
    </span>
</g:each>
    %{--</ul>--}%
</div>

    %{--new one (accordion)--}%
%{--<div style="-moz-column-count: 4">--}%
    %{--<ul>--}%
        %{--<g:each in="${Tag.list([sort: 'name', order: 'asc'])}" var="t">--}%
            %{--<li style="list-style-type: circle; font-size: ${13 + (t.occurrence ? Math.ceil(Math.log(t.occurrence)) : 0)}px; line-height: 18px;">--}%
                %{--<g:remoteLink controller="generics" action="tagReport" id="${t.id}"--}%
                              %{--update="centralArea">--}%
                    %{--${t.name} <sup><i>${t.occurrence}</i></sup>--}%
                %{--</g:remoteLink>--}%
            %{--</li>--}%
        %{--</g:each>--}%
    %{--</ul>--}%
%{--</div>--}%
