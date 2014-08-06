<%@ page import="ker.OperationController; cmn.Setting;" %>


<div  class="nav nonPrintable"
      style="width: 98%; padding: 3px;">

&nbsp;
    <img src="${resource(dir: 'images', file: 'favicon-32px.png')}" width="15px;"/>
    %{--target="_blank"--}%
    <g:link controller="page" action="main"

            title="Reload the application">
        <span style="color: #fff;">
        <b style="font-size: 13px; font-family: Trebuchet MS, Verdana, Geneva, Arial, Helvetica, sans-serif;">
            ${OperationController.getPath('app.name') ?: 'Pomegranate PKM'}</b> &nbsp;
        <sup><i>v</i><g:meta name="app.version"/></sup>
        </span>
    </g:link>
<g:if test="${OperationController.getPath('show.textlogo')?.toLowerCase() == 'yes' ? true : false}">
<sub>
    <a href="http://pomegranate-pkm.org" target="_blank">
        <i style="font-size: 10px; color: #ffffff">A Pomegranate PKM system</i>
    </a>
</sub>
      </g:if>

&nbsp;

    <% Calendar c = new GregorianCalendar(); c.setLenient(false); c.setMinimalDaysInFirstWeek(4);
    c.setFirstDayOfWeek(java.util.Calendar.MONDAY)
    %>
    <b>Week ${c.get(Calendar.WEEK_OF_YEAR)}</b>
&nbsp;


&nbsp;
&nbsp;
&nbsp;


&nbsp;
&nbsp;
&nbsp;

    <g:remoteLink controller="report" action="detailedAdd"
                  update="centralArea"
                  before="jQuery.address.value(jQuery(this).attr('href'));"
                  style="color: white !important"
                  title="Add using formas">
        Add...
    </g:remoteLink>


&nbsp;
&nbsp;

    <g:if test="${OperationController.getPath('import.enabled')?.toLowerCase() == 'yes' ? true : false}">
        <g:remoteLink controller="import" action="importLocalFiles"
                      update="centralArea"
                      before="jQuery.address.value(jQuery(this).attr('href'));"
                      style="color: white !important"
                      title="Import local files">
            Import...
        </g:remoteLink>
    </g:if>
&nbsp;
&nbsp;
    <g:remoteLink controller="report" action="tagCloud"
                  update="tagsPanel"
        before="jQuery('#accordionEast').accordion({ active: 1});"
      style="color: white !important"
                  title="Tag cloud">
        Tags...
    </g:remoteLink>


&nbsp;
&nbsp;
    <g:remoteLink controller="report" action="contactCloud"
                  update="contactsPanel"
        before="jQuery('#accordionEast').accordion({ active: 2});"
      style="color: white !important"
                  title="Contact cloud">
        Contacts...
    </g:remoteLink>





    %{--<g:remoteLink controller="report" action="tagCloud"--}%
                  %{--update="centralArea"--}%
                  %{--class=" fg-button fg-button-icon-left ui-widget ui-state-default ui-corner-all"--}%
                  %{--title="Tag cloud">--}%
        %{--<span class="ui-icon ui-icon-tag"></span> Tags--}%
    %{--</g:remoteLink>--}%
%{--&nbsp;--}%


    %{--<g:remoteLink controller="report" action="rss"--}%
                  %{--update="centralArea"--}%
                  %{--class=" fg-button fg-button-icon-solo ui-widget ui-state-default ui-corner-all"--}%
                  %{--title="Tag cloud">--}%
        %{--<span class="ui-icon ui-icon-signal"></span>--}%
    %{--</g:remoteLink>--}%
%{--&nbsp;--}%





&nbsp;
&nbsp;
&nbsp;


    <sec:ifLoggedIn>
        <sec:ifAnyGranted roles="ROLE_ADMIN">
            <g:link controller='user' >

                <b style="color: #ffffff;"><sec:username/></b>

            </g:link>
        </sec:ifAnyGranted>
        <sec:ifNotGranted roles="ROLE_ADMIN">
            <b style="color: #ffffff;"><sec:username/></b>

        </sec:ifNotGranted>



        <g:link controller='logout' style="color: #ffffff !important;">Logout &nbsp;</g:link>
    </sec:ifLoggedIn>
    <sec:ifNotLoggedIn>
        <a href='#' id='loginLink'>Login</a>
    </sec:ifNotLoggedIn>

&nbsp;


<g:formRemote name="batchAdd2"
              url="[controller: 'generics', action: 'actionDispatcher']"
              update="centralArea" style="display: inline"
              method="post">

    <g:hiddenField name="sth2" value="${new java.util.Date()}"/>
        <g:submitButton name="batch" value="Execute"
                        style="height: 20px; margin: 0px; width: 200px !important; display: none"
                        id="quickAddXcdSubmitTop"
                        class="fg-button ui-widget ui-state-default"/>

            <g:textField name="input" id="quickAddTextFieldBottomTop" value=""
                        autocomplete="off"
                         style="display: inline;  width: 300px !important"
                        placeholder="Command bar"
                        onkeyup="if (jQuery('#quickAddTextField').val().search(';')== -1){jQuery('#hintArea').load('${createLink(controller: 'generics', action: 'commandBarAutocomplete')}?hint=1&q=' + encodeURIComponent(jQuery('#quickAddTextField').val()))}"
                        onfocus="jQuery('#hintArea').load('${createLink(controller: 'generics', action: 'commandBarAutocomplete')}?hint=1&q=' + encodeURIComponent(jQuery('#quickAddTextField').val()))"
                        onblur="jQuery('#hintArea').html('')"
                        class="commandBarTexFieldTop"/>

</g:formRemote>


&nbsp;
&nbsp;

    <g:formRemote name="searchField" url="[controller: 'generics', action: 'quickSearch']" update="centralArea"
                  method="post" style="display: inline; "
                  onComplete="">
    %{--<g:textField id="courseTest" class="ui-corner-all" style="width:150px;" name="q"/>--}%
        <g:textField id="searchField" name="q" style="width: 150px; margin: 1px; background: #ffffff"
                     type="text"
                     placeholder="Quick search..."
                     title=""/>
        <g:submitButton class="" style="visibility: hidden;"
                        name="submit" value="s"/>
    </g:formRemote>



</div>
