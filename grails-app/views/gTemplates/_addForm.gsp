<%@ page import="mcs.Department; mcs.parameters.WorkStatus;" %>

<g:if test="${record}">
    <g:render template="/gTemplates/recordSummary" model="[record: record]"/>
</g:if>

%{--<g:if test="${hideForm}">--}%
<g:formRemote name="genericSearch" url="[controller: 'generics', action: 'saveViaForm']"
              update="${updateRegion}" method="post" style="display: inline;" onComplete="">

<b>${entityController?.split(/\./).last()}</b>



<g:hiddenField name="entityController" value="${entityController}"/>
<g:hiddenField name="updateRegion" value="${updateRegion}"/>

<g:hiddenField name="id" value="${record?.id}"/>


<table>
<tr>


        <g:if test="${fields.contains('numberCode')}">
            <td>          <g:textField name="numberCode" placeholder="Number Code" class="ui-corner-all" value="${record?.numberCode}"/>
            </td>
        </g:if>


    
    

        <g:if test="${fields.contains('username')}">
            <td>
            <g:textField name="username" placeholder="Username" class="ui-corner-all" value="${record?.username}"/>
            </td>
        </g:if>


        <g:if test="${fields.contains('password')}">
            <td>
            <g:textField name="password" placeholder="Password" class="ui-corner-all" value="${record?.password}"/>
            </td>
        </g:if>

    
    

        <g:if test="${fields.contains('code')}">
            <td>
            <g:textField name="code" placeholder="Code" class="ui-corner-all" value="${record?.code}"/>
            </td>
        </g:if>


        <g:if test="${fields.contains('name')}">
            <td>
            <g:textField name="name" placeholder="Name" class="ui-corner-all" value="${record?.name}"/>
            </td>

        </g:if>


        <g:if test="${fields.contains('value')}">
            <td>
            <g:textField id="value" name="value" placeholder="Value" style="width: 180px;" class="ui-corner-all"
                         value="${record?.value}"/>
            </td>
        </g:if>



</tr>

<tr>

    <g:if test="${fields.contains('summary')}">
        <td colspan="3">
            <g:textField placeholder="Summary" name="summary" value="${record?.summary}" style="width: 95%;"/>
        </td>
    </g:if>

    <g:if test="${fields.contains('title')}">
        <td colspan="3">
            <g:textField placeholder="Title" name="title" value="${record?.title}" style="width: 150px;"/>
        </td>
    </g:if>
    <g:if test="${fields.contains('isbn')}">
        <td colspan="1">
            <g:textField placeholder="ISBN" name="isbn" value="${record?.isbn}" style="width: 150px;"/>
        </td>
    </g:if>
    <g:if test="${fields.contains('link')}">
        <td colspan="3">
            <g:textField placeholder="link (should start with http and ends with /xmlrpc.php" name="link"
                         value="${record?.link}" style="width: 150px;"/>
        </td>
    </g:if>


    <g:if test="${fields.contains('style')}">
        <td>
            <g:textField id="style" name="style" placeholder="CSS Style" style="width: 120px;" class="ui-corner-all"
                         value="${record?.style}"/>
        </td>
    </g:if>

</tr>
<tr>


    <g:if test="${fields.contains('query')}">
        <td colspan="4">
            <g:textField placeholder="Query" rows="5" name="query" value="${record?.query}"
                         style="width: 95%;"/>

    </g:if>


    <g:if test="${fields.contains('countQuery')}">
        <br/>
        <g:textField placeholder="Count query" name="countQuery" value="${record?.countQuery}"
                     style="width: 95%;"/>
        </td>
    </g:if>

    <g:if test="${fields.contains('sourceFree')}">
        <td colspan="3">
            <g:textField placeholder="Source (Link, citation, etc)" id="sourceFree" name="sourceFree" style="width: 95%;"
                         class="ui-corner-all"
                         value="${record?.sourceFree}"/>
        </td>
    </g:if>





    <g:if test="${fields.contains('url')}">
        <td colspan="3">
        <g:textField placeholder="url" rows="5" name="url" value="${record?.url}"
                     style="width: 95%;"/>
      </td>
    </g:if>
    
    
    
    

    <g:if test="${fields.contains('completedOn')}">
        <td>
            <pkm:datePicker name="completedOn" placeholder="Completed on" value="${record?.completedOn}"/>
        </td>
    </g:if>

</tr>

<tr>

    <g:if test="${fields.contains('description')}">
        <td colspan="2">
            <g:textArea cols="80" rows="5" placeholder="Description" name="description"
                        value="${record?.description}"
                        style="width: 95%; height: 100px;"/>
        </td>
    </g:if>

    <g:if test="${fields.contains('shortDescription')}">
        <td colspan="2">
            <g:textArea cols="80" rows="5" placeholder="Short description for presentation" name="shortDescription"
                        value="${record?.shortDescription}"
                        style="width: 95%;  height: 100px;"/>
        </td>
    </g:if>


   

    


</tr>


<tr>


        <g:if test="${fields.contains('department')}">
            <td>
            <g:select name="department.id" style="width: 200px;" from="${departments}"
                      value="${record?.department?.id}" optionKey="id"
                      noSelection="${['null': 'No department']}"/>
</td>
        </g:if>

    <g:if test="${fields.contains('course')}">
        <td>    <g:select name="course.id" style="width: 200px;" from="${courses}"
                          value="${record?.course?.id}"
                          optionKey="id" noSelection="${['null': 'No course']}"/>
        </td>
    </g:if>


        <g:if test="${fields.contains('source')}">
            <td>
            <g:select name="source.id" class="ui-corner-all"
                      from="${sources}" optionKey="id"
                      value="${record?.source?.id}"
                      noSelection="${['null': 'No person']}"/>
            </td>
        </g:if>



        <g:if test="${fields.contains('indicator')}">
            <td>
            <g:select name="indicator.id" class="ui-corner-all"
                      from="${indicators}"
                      optionKey="id" optionValue="code"
                      value="${record?.indicator?.id ?: (session['lastIndicatorId'] ?: null)}"
                      noSelection="${['null': '']}"/>
            </td>
        </g:if>



        <g:if test="${fields.contains('category')}">
          <td>
            <g:select name="category.id" class="ui-corner-all"
                      from="${app.PaymentCategory.list()}" optionKey="id"
                      value="${record?.category?.id}"
                      noSelection="${['null': '']}"/>
            </td>
        </g:if>








        <g:if test="${fields.contains('writing')}">
            <td>     <g:select name="writing.id" from="${writings}" style="width: 150px;"
                      optionKey="id"
                      value="${record?.writing?.id ?: (session['writingId'] ?: null)}"
                      noSelection="['null': 'No writing']"/>
            </td>
        </g:if>



        <g:if test="${fields.contains('book')}">
            <td>    <g:textField placeholder="Book ID" id="book.id" name="book.id" style="width: 60px"
                         class="ui-corner-all"
                         value="${record?.book?.id ?: (bookId ?: null)}"/>
            </td>
        </g:if>


</tr>


<tr>

    <g:if test="${fields.contains('newFilesPath')}">
        <td>
            <g:textField placeholder="Path of its location in the new folder" id="newFilesPath" name="newFilesPath" style="width: 200px"
                         class="ui-corner-all"
                         value="${record?.newFilesPath ?: null}"/>
        </td>
    </g:if>
    <g:if test="${fields.contains('repositoryPath')}">
        <td>
            <g:textField placeholder="Path of its location in the repository" id="repositoryPath" name="repositoryPath" style="width: 200px"
                         class="ui-corner-all"
                         value="${record?.repositoryPath ?: null}"/>
        </td>
    </g:if>



    <g:if test="${fields.contains('type')}">
        <td>

            <g:select name="type.id" style="width: 150px;"
                      from="${types}" optionKey="id" optionValue="name"
                      value="${record?.type?.id}"
                      noSelection="${['null': 'Any type']}"/>
        </td>
    </g:if>





    <g:if test="${fields.contains('queryType')}">
        <td>
            <g:select name="queryType" from="${['hql', 'lucene', 'adhoc']}" value="${record?.queryType}"/>
        </td>
    </g:if>





        <g:if test="${fields.contains('status')}">
            <td>      <g:select name="status.id" style="width: 150px;"
                      from="${statuses}" optionKey="id" optionValue="name"
                      value="${record?.status?.id}"
                      noSelection="${['null': 'Any status']}"/>
</td>
        </g:if>


        <g:if test="${fields.contains('location')}">
<td>
            <g:select name="location.id" style="width: 150px;"
                      from="${locations}" optionKey="id" optionValue="name"
                      value="${record?.location?.id}"
                      noSelection="${['null': 'Any location']}"/>
</td>
        </g:if>

        <g:if test="${fields.contains('context')}">
<td>
            <g:select name="context.id" style="width: 150px;"
                      from="${contexts}" optionKey="id" optionValue="name"
                      value="${record?.context?.id}"
                      noSelection="${['null': 'Any context']}"/>
</td>
        </g:if>





        <g:if test="${fields.contains('entity')}">
            <td>
            <g:textField id="entity" name="entity" placehoder="Panel" style="width: 50px;" value="${record?.entity}"/>
            </td>
        </g:if>



        <g:if test="${fields.contains('priority')}">
          <td>
            p<g:select name="priority" placehoder="Priority" style="width: 50px;"
                       from="${[1, 2, 3, 4]}"
                       value="${record?.priority}"/>
          </td>
        </g:if>





        <g:if test="${fields.contains('level')}">
          <td>  <g:select name="level" value="${record?.level}"
                      from="${['i', 'd', 'w', 'm', 'y', 'e', 'l']}"
                      noSelection="${['null': 'Any level']}"/>
          </td>
        </g:if>







        <g:if test="${fields.contains('orderInCourse')}">
            <td>
                <g:textField name="orderInCourse" value="${fieldValue(bean: record, field: 'orderInCourse')}"
                         placeholder="# crs"
                         style="width: 20px;"/>

            </td>
        </g:if>
     <g:if test="${fields.contains('orderNumber')}">
            <td>
                <g:textField name="orderNumber" value="${fieldValue(bean: record, field: 'orderNumber')}"
                         placeholder="# crs"
                         style="width: 20px;"/>

            </td>
        </g:if>





        <g:if test="${fields.contains('pages')}">
           <td>
            <g:textField placeholder="Pages" id="pages" name="pages" style="width: 50px" class="ui-corner-all"
                         value="${record?.pages}"/>
           </td>
        </g:if>




        <g:if test="${fields.contains('language')}">
       <td>
            <g:textField placeholder="Lang. code" name="language" style="width: 100px" value="${record?.language}"/>
       </td>
        </g:if>



        <g:if test="${fields.contains('chapters')}">
       <td>
            <g:textField name="chapters" placeholder="Chap." value="${fieldValue(bean: record, field: 'chapters')}"/>
            </td> </g:if>



</tr>


<tr>


        <g:if test="${fields.contains('startDate')}">
            <td>        <pkm:datePicker placeholder="Start date" name="startDate" value="${record?.startDate}"/>
            <g:textField name="startTime" style="width:60px;" placeholder="Time"
                         value="${record?.startDate ? record?.startDate?.format('HH.mm') : '00.00'}"/>
            </td>
        </g:if>



        <g:if test="${fields.contains('date')}">
         <td>
            <pkm:datePicker name="date" style="width: 70px;-moz-border-radius: 4px;" extraParams=""
                             placeholder="Date"
                             value="${record?.date ?: (session['lastDate'] ?: new Date())}"/>
         </td>
        </g:if>




        <g:if test="${fields.contains('endDate')}">
            <td>    <pkm:datePicker placeholder="End date" name="endDate" value="${record?.endDate}"/>
            <g:textField name="endTime" style="width:60px;" placeholder="Time"
                         value="${record?.endDate ? record?.endDate?.format('HH.mm') : '00.00'}"/>
            </td>  </g:if>




        <g:if test="${fields.contains('amount')}">
        <td>
            <g:textField id="amount" name="amount" placeholder="Amount" style="width: 90px;" class="ui-corner-all"
                         value="${record?.amount}"/>
        </td>
        </g:if>





        <g:if test="${fields.contains('isDayChallenge')}">
            <td>
                 <g:checkBox name="isDayChallenge" value="${record?.isDayChallenge}"/> Is day challenge?
            </td>
        </g:if>



      <g:if test="${fields.contains('isCategory')}">
    <td>
       <g:checkBox id="isCategory" name="isCategory" value="${record?.isCategory}"
                        style="width: 15px;"/>  Is category?
    </td>
      </g:if>

      <g:if test="${fields.contains('bookmarked')}">
    <td>
        <g:checkBox id="bookmarked" name="bookmarked" value="${record?.bookmarked}"
                        style="width: 15px;"/> Bookmarked?
    </td>
      </g:if>


        %{--<g:if test="${fields.contains('onHomepage')}">--}%
        %{--<td>    <g:checkBox id="onHomepage" name="onHomepage" value="${record?.onHomepage}"--}%
                        %{--style="width: 15px;"/> On homepage?--}%
        %{--</td>--}%
        %{--</g:if>--}%
      <g:if test="${fields.contains('captureIsbn')}">
        <td>    <g:checkBox id="captureIsbn" name="captureIsbn" value="${record?.captureIsbn}"
                        style="width: 15px;"/> Capture ISBN in file names?
        </td>
        </g:if>


</tr>

<tr>

        <g:if test="${fields.contains('reality')}">
            <td colspan="2">
            <g:textArea placeholder="Reality" name="reality" cols="40" rows="5" value="${record?.reality}"/>
            </td>
        </g:if>



    <g:if test="${fields.contains('bibEntry')}">
        <td colspan="1">
            <g:textArea cols="80" rows="5" id="bibEntry" placeholder="bibEntry" name="bibEntry"
                        style="width: 95%; max-width: 90px" class="ui-corner-all"
                        value="${record?.bibEntry}"/>
        </td>
    </g:if>
     <g:if test="${fields.contains('notes')}">
        <td colspan="1">
            <g:textArea cols="80" rows="5" id="notes" placeholder="Notes" name="notes"
                        style="width: 95%; max-width: 90px" class="ui-corner-all"
                        value="${record?.notes}"/>
        </td>
    </g:if>
    
   

</tr>


 <g:if test="${fields.contains('citationText')}">
     <tr>
    <td colspan="4">
        <g:textField placeholder="citationText" rows="5" name="citationText" value="${record?.citationText}"
                     style="width: 95%;"/>
    </td>

     </tr>
     <tr>
    <td colspan="4">
        <g:textField placeholder="citationHtml" rows="5" name="citationHtml" value="${record?.citationHtml}"
                     style="width: 95%;"/>
    </td>

     </tr>
     <tr>
    <td colspan="4">
        <g:textField placeholder="citationAsciicode" rows="5" name="citationAsciicode" value="${record?.citationAsciicode}"
                     style="width: 95%;"/>
    </td>

     </tr>
</g:if>


</table>





<g:submitButton class="fg-button ui-icon-left ui-widget ui-state-default ui-corner-all" name="submit"
                value="Save"
                onsubmit="jQuery('#searchResults').html('')"/>

</g:formRemote>
%{--</g:if>--}%

<g:if test="${savedRecord && !record}">
    <g:render template="/gTemplates/recordSummary" model="[record: savedRecord]"/>
</g:if>