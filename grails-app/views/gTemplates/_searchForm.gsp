<%@ page import="mcs.Department; mcs.parameters.WorkStatus;" %>


<!-- searchForm -->

%{--<g:checkBox name="isTopic"/> Is a topic?<br/>--}%
<g:hiddenField name="entityCode" value="${entityCode}"/>


Full text<br/>
<g:textField name="fullText" style="width: 150px;"/>
<br/>


%{--Summary<br/>--}%
%{--<g:textField name="summary" style="width: 150px;"/>--}%
%{--<br/>--}%


%{--Description<br/>--}%
%{--<g:textField name="description" style="width: 150px;"/>--}%
%{--<br/>--}%


%{--Notes<br/>--}%
%{--<g:textField name="notes" style="width: 150px;"/>--}%
%{--<br/>--}%


Date range of <g:select name="dateField"
                        from="${['startDate', 'endDate', 'dateCreated', 'lastUpdated']}"
                        noSelection="${['null': 'Any date']}"/>
<br/>

between <g:textField name="dateA" style="width: 50px;" value="-"/>
and <g:textField name="dateB" style="width: 50px;" value=""/>

<br/>

<g:if test="${'GTPJWNR'.contains(entityCode)}">

    <g:select name="type" style="width: 150px;"
              from="${types}" optionKey="id" optionValue="value"
              noSelection="${['null': 'Any type']}"/>
    <br/>
</g:if>



<g:if test="${'GTPR'.contains(entityCode)}">
    <g:select name="status" style="width: 150px;"
              from="${statuses}" optionKey="id" optionValue="value"
              noSelection="${['null': 'Any status']}"/>
    <br/>

</g:if>

<g:if test="${'T'.contains(entityCode)}">

    <g:select name="location" style="width: 150px;"
              from="${locations}" optionKey="id" optionValue="value"
              noSelection="${['null': 'Any location']}"/>
    <br/>
</g:if>


<g:select name="department" style="width: 150px;"
          from="${departments}" optionKey="id" optionValue="value"
          noSelection="${['null': 'Any department']}"/>
<br/>


<g:select name="course" style="width: 150px;"
          from="${courses}" optionKey="id" optionValue="value"
          noSelection="${['null': 'Any course']}"/>
<br/>

<g:if test="${'JP'.contains(entityCode)}">
    <g:select name="level"
              from="${['i', 'd', 'w', 'm', 'y', 'e', 'l']}"
              noSelection="${['null': 'Any level']}"/>
    <br/>
</g:if>


<g:select name="priority"
          from="${[1, 2, 3, 4]}"
          noSelection="${['null': 'Any priority']}"/>

<br/>
<g:if test="${'R'.contains(entityCode)}">
    <g:checkBox name="withExcerpts" value="${false}"/> With excerpts?
%{--Todo: implement--}%s
    <br/>
</g:if>


