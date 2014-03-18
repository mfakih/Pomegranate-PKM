<%@ page import="mcs.Course; mcs.parameters.WritingType; mcs.parameters.ResourceStatus; mcs.Book; app.IndexCard" %>


%{--<g:hiddenField name="entityCode" value="${recordEntityCode}"></g:hiddenField>--}%
%{--<g:hiddenField name="recordId" value="${recordId}"></g:hiddenField>--}%

    <table>
        <tbody>

<tr>
    <td colspan="2">

        %{--<label for="description">Description--}%
        %{--</label>--}%
        <g:textField placeholder="Summary"  id="summary" name="summary" style="width: 300px;" class="ui-corner-all"
                     value="${indexCardInstance?.summary}"/>
              <g:select name="type.id" class="ui-corner-all" style="width: 100px"
                              from="${WritingType.list([sort: 'name'])}" optionKey="id" optionValue="code"
                              value="${indexCardInstance?.type?.id ?: (session['lastIcdTypeId'] ?: null)}"
                              noSelection="${['null': 'No type']}"/>
        <br/>
        <g:textArea placeholder="Description"  id="description" name="description" style="width: 450px; height: 70px;"
                    class="ui-corner-all"
                    cols="40" rows="5" value="${indexCardInstance?.description}"/>
       <br/>
        <g:textField placeholder="Source"  id="sourceFree" name="sourceFree" style="width: 450px;" class="ui-corner-all"
                     value="${indexCardInstance?.sourceFree}"/>

    </td>
    <td valign="top" class="value ${hasErrors(bean: indexCardInstance, field: 'source', 'errors')}">


        <g:select name="source.id" class="ui-corner-all"
                  from="${app.parameters.WordSource.list([sort: 'name'])}" optionKey="id"
                  value="${indexCardInstance?.source?.id}"
                  noSelection="${['null': 'No source']}"/>
    %{--</td>  <td valign="top" class="value ${hasErrors(bean: indexCardInstance, field: 'writing', 'errors')}">--}%

        <br/>
        <g:select name="writing.id" from="${mcs.Writing.list([sort: 'summary'])}" style="width: 150px;"
                  optionKey="id" value="${indexCardInstance?.writing?.id ?: (writingId ?: null)}" noSelection="['null': 'No writing']"/>

                               <br/>

        B-


        <g:textField placeholder="Book ID"  id="book.id" name="book.id" style="width: 60px" class="ui-corner-all"
                     value="${indexCardInstance?.book?.id ?: (bookId ?: null)}"/>




        <g:textField placeholder="Page"  id="pages" name="pages" style="width: 50px" class="ui-corner-all"
                     value="${indexCardInstance?.pages}"/>

        <br/>
        <g:select name="course.id" style="width: 200px;" from="${Course.list([sort: 'code'])}"
                  value="${indexCardInstance?.course?.id}" optionKey="id" noSelection="${['null': 'No course']}"/>
        <br/>
      <g:textField placeholder="Lang." name="language" style="width: 50px" value="${indexCardInstance?.language}"/>
        %{--<g:textField name="orderNumber"  value="${indexCardInstance?.orderNumber}" style="width: 50px;"/>--}%



</td>
</tr>






</tbody>
</table>

<script>
    jQuery("#contents").focus();

    //    jQuery("#book").autocomplete(
    //            "${contextPath}/book/autoCompleteBooks", {
    //                mustMatch:false, minChars:4, selectFirst:false, highlight:false, autoFill:false, multipleSeparator:' ', multiple:false, delay:200,
    //                formatResult:function (data, p, l) {
    //                    return data[1]
    //                }
    //            });
</script>

