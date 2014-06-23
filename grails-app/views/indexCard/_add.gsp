<%@ page import="mcs.Book; mcs.Writing; mcs.Course; mcs.parameters.WritingType" %>



<g:if test="${recordEntityCode && recordId}">

    <g:each in="${app.IndexCard.findAllByEntityCodeAndRecordId(recordEntityCode, recordId, [sort: 'dateCreated', order: 'asc'])}"
            var="c">
        <g:render template="/gTemplates/box" model="[record: c]"/>
    </g:each>
</g:if>

<g:if test="${writingId && Writing.get(writingId) != null}">
    <g:each in="${app.IndexCard.findAllByWriting(Writing.get(writingId), [sort: 'dateCreated', order: 'asc'])}"
            var="c">
        <g:render template="/gTemplates/box" model="[record: c]"/>
    </g:each>
</g:if>

<g:if test="${bookId && Book.get(bookId) != null}">

    <g:each in="${app.IndexCard.findAllByBook(Book.get(bookId), [sort: 'dateCreated', order: 'asc'])}" var="c">
        <g:render template="/gTemplates/box" model="[record: c]"/>
    </g:each>
</g:if>



%{--<h4>Attach index card</h4> recordEntityCode != 'Bx' && recordEntityCode != 'Wx' &&  --}%
<g:if test="${recordEntityCode != 'C'}">

<g:formRemote name="save" url="[controller: 'indexCard', action: 'attach']" update="panelComments${recordEntityCode}Record${recordId}" method="post"
              onComplete="">

              
<g:if test="${writingId || bookId}">

     <div class="dialog">
   <g:render template="/indexCard/form" model="[indexCardInstance: indexCardInstance, writingId: writingId, bookId: bookId]"/>
    </div>
    
    
</g:if>
<g:else>
    <g:hiddenField name="entityCode" value="${recordEntityCode}"></g:hiddenField>
    <g:hiddenField name="recordId" value="${recordId}"></g:hiddenField>
    
     <div class="dialog">
   <g:render template="/indexCard/form" model="[indexCardInstance: indexCardInstance]"/>
    </div>
     
    
    </g:else>

   
    <g:submitButton name="create" value="${message(code: 'save', 'default': 'Save')}"
                    class="fg-button ui-widget ui-state-default ui-corner-all"/>
</g:formRemote>

    </g:if>
