<%@ page import="mcs.parameters.SavedSearch; mcs.Task" %>
<g:if test="${!params.disableSavedSearch}">
    <g:each in="${SavedSearch.findAllByEntityLike(entity, [sort: 'summary'])}" var="i">

            <g:remoteLink controller="generics" action="getAddForm" id="${i.id}"
                          params="[entityController: 'mcs.parameters.SavedSearch',
                                  updateRegion: 'centralArea',
                                  finalRegion: 'centralArea']"
                          update="centralArea"
                          title="Edit">
                *
            </g:remoteLink>

            <g:set var="split" value="\\{"/>

            <g:set var="count"
                   value="${i.countQuery ? Task.executeQuery(i.countQuery)[0] : null}"/>


            <g:remoteLink controller="generics" action="executeSavedSearch"
                          style=" color: #${count > 0 ? '003366' : (count == 0 ? 'ccc' : 'aaa')}"
                          id="${i.id}"
                          before="jQuery.address.value(jQuery(this).attr('href'));"
                          update="centralArea">
                ${i.summary} ${count != null ? '(' + count + ')' : null}

            </g:remoteLink>
            <g:if test="${i.queryType == 'hql'}">
           <sup>
            <g:remoteLink controller="generics" action="executeSavedSearch"
                          style=" color: gray"
                          before="jQuery.address.value(jQuery(this).attr('href'));"
                          id="${i.id}" params="[reportType: 'random']"
                          update="centralArea">
                r

            </g:remoteLink>
           </sup>
                <sup>
            <g:link controller="generics" action="executeSavedSearch"
                          style=" color: gray"
                          id="${i.id}" params="[reportType: 'tab']"
                          target="_blank">
                tab
            </g:link>
           </sup>  <sup>
            <g:link controller="generics" action="executeSavedSearch"
                    style=" color: gray"
                          id="${i.id}" params="[reportType: 'cal']"
                          target="_blank">
                cal
            </g:link>
           </sup>
            </g:if>


       <br/>

    </g:each>
</g:if>
