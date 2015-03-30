<%@ page import="cmn.Setting; mcs.Course; mcs.parameters.WritingType; mcs.parameters.ResourceStatus; mcs.Book; app.IndexCard" %>


%{--<g:hiddenField name="entityCode" value="${recordEntityCode}"></g:hiddenField>--}%
%{--<g:hiddenField name="recordId" value="${recordId}"></g:hiddenField>--}%

    <table style="width: 95%">
        <tbody>

<tr>
    <td colspan="1">

        %{--<label for="description">Description--}%
        %{--</label>--}%

        <pkm:datePicker name="writtenOn" placeholder="Written on" value="${indexCardInstance?.writtenOn}"/>

               <g:select name="type.id" class="ui-corner-all" style="width: 100px"
                              from="${WritingType.list([sort: 'name'])}" optionKey="id" optionValue="name"
                              value="${indexCardInstance?.type?.id ?: (session['lastIcdTypeId'] ?: WritingType.findByCode('hgl').id)}"


                              noSelection="${['null': 'No type']}"/>

        <g:select name="writing.id" from="${mcs.Writing.list([sort: 'summary'])}" style="width: 100px;"
                  optionKey="id" value="${indexCardInstance?.writing?.id ?: (writingId ?: null)}"
                  noSelection="['null': 'No writing']"/>

<g:if test="${Setting.findByName('course.enabled')?.value ==  'yes'}">
        <g:select name="course.id" style="width: 100px;" from="${Course.list([sort: 'code'])}"
                  value="${indexCardInstance?.course?.id}" optionKey="id" noSelection="${['null': 'No course']}"/>
    </g:if>

        <g:textField placeholder="Page" id="pages" name="pages" style="width: 50px" class="ui-corner-all"
                     value="${indexCardInstance?.pages}"/>

        <g:select name="language" from="${['ar', 'en', 'fr']}"
        style="width: 50px" value="${language ?: indexCardInstance?.language}"/>

        %{--<g:textField name="orderNumber"  value="${indexCardInstance?.orderNumber}" style="width: 50px;"/>--}%

        <br/>
        <g:textField placeholder="Summary"  id="summary" name="summary" style="width: 99%;" class="ui-corner-all"
                     value="${indexCardInstance?.summary}"/>

        <g:textArea placeholder="Description"  id="description" name="description" style="width: 99%; height: 70px;"
                    class="ui-corner-all"
                    cols="40" rows="5" value="${indexCardInstance?.description}"/>

        <g:textField placeholder="sourceFree"  id="sourceFree" name="sourceFree" style="width: 99%;" class="ui-corner-all"
                     value="${indexCardInstance?.sourceFree}"/>

       %{--<br/>--}%
        %{--<g:textField placeholder="Source"  id="sourceFree" name="sourceFree" style="width: 99%;" class="ui-corner-all"--}%
                     %{--value="${indexCardInstance?.sourceFree}"/>--}%

    </td>
    </tr>
        %{--<tr>--}%
    %{--<td valign="top" class="value ${hasErrors(bean: indexCardInstance, field: 'source', 'errors')}">--}%


        %{--<g:select name="source.id" class="ui-corner-all"--}%
                  %{--from="${app.parameters.WordSource.list([sort: 'name'])}" optionKey="id"--}%
                  %{--value="${indexCardInstance?.source?.id}"--}%
                  %{--noSelection="${['null': 'No source']}"/>--}%
    %{--</td>  <td valign="top" class="value ${hasErrors(bean: indexCardInstance, field: 'writing', 'errors')}">--}%

        %{--<br/>--}%

        %{--B---}%
        %{--<g:textField placeholder="Book ID"  id="book.id" name="book.id" style="width: 60px" class="ui-corner-all"--}%
                     %{--value="${indexCardInstance?.book?.id ?: (bookId ?: null)}"/>--}%




%{--</td>--}%
%{--</tr>--}%






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

