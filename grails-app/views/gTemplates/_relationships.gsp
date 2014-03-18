<%@ page import="mcs.parameters.RelationshipType; mcs.Relationship" %>

%{--<h4>Relationships</h4>--}%

%{--<g:each in="${Relationship.findAll()}" var="t">--}%
%{--dump: ${t.id} ---}%
%{--${t.entityA}  - ${t.recordA} ---}%
%{--${t.entityB}  -${t.recordB}  ---}%


%{--${t.type}  ---}%
%{--</g:each>--}%

<g:each in="${RelationshipType.findAll()}" var="type">
    <g:if test="${Relationship.executeQuery('select count(*) from Relationship where (entityA = ? or entityA = ? or entityA = ?) and recordA = ? and type = ? ',
            ['mcs.' + record.entityController(), 'app.' + record.entityController(), 'app.parameters.' + record.entityController(), record.id, type])[0] > 0}">
        <b>${type.name}</b>:
        <br/>

        <g:each in="${Relationship.executeQuery('from Relationship where (entityA = ? or entityA = ? or entityA = ?) and recordA = ? and type = ? ',
                ['mcs.' + record.entityController(), 'app.' + record.entityController(), 'app.parameters.' + record.entityController(), record.id, type])}"
                status="c"
                var="t">
            <table border="0">
                <tr>
                    <td>
                        <g:remoteLink controller="relationship" action="delete" id="${t.id}"
                                      update="notificationArea"
                                      before="if(!confirm('Are you sure you want to delete the relationship?')) return false"
                                      title="Logical delete">
                            x
                        </g:remoteLink>
                    </td>
                    <td>
                        %{--todo: works only for mcs package --}%
                        <g:render template="/gTemplates/recordSummary"
                                  model="[record: grailsApplication.classLoader.loadClass(t.entityB).get(t.recordB)]"/>

                    </td>
                </tr>
            </table>

        </g:each>

    </g:if>



    <g:if test="${Relationship.executeQuery('select count(*) from Relationship where (entityB = ? or entityB = ? or entityB = ?) and recordB = ? and type = ? ',
            ['mcs.' + record.entityController(), 'app.' + record.entityController(), 'app.parameters.' + record.entityController(), record.id, type])[0] > 0}">
        <b>${type.inverseName ?: '?'}</b>:

        <g:each in="${Relationship.executeQuery('from Relationship where (entityB = ? or entityB = ? or entityB = ?) and recordB = ? and type = ? ',
                ['mcs.' + record.entityController(), 'app.' + record.entityController(), 'app.parameters.' + record.entityController(), record.id, type])}"
                status="c"
                var="t">

        %{--todo: works only for mcs package --}%
            <g:render template="/gTemplates/recordSummary"
                      model="[record: grailsApplication.classLoader.loadClass(t.entityA).get(t.recordA)]"/>
        </g:each>

    </g:if>
</g:each>

