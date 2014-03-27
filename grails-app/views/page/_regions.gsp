<%@ page import="ker.OperationController" %>
<!-- manually attach allowOverflow method to pane -->
<div class="ui-layout-north northRegion">
    <g:render template="/layouts/north" model="[]"/>

</div>

<!-- allowOverflow auto-attached by option: west__showOverflowOnHover = true -->
<div class="ui-layout-west westRegion">
    <g:render template="/layouts/west"/>
    %{--<p><button onclick="myLayout.close('west')">Hide</button></p>--}%

</div>

<div class="ui-layout-south southRegion">

    <g:render template="/layouts/south"/>

    <!-- this button has its event added dynamically in document.ready -->
    %{--<button class="south-toggler">Hide</button>--}%
</div>


    <div class="ui-layout-east eastRegion">

        <div id="3rdPanel"></div>
        %{--<g:if test="${ker.OperationController.getPath('twoPanels') == 'on'}">--}%
        %{--<g:render template="/layouts/east"/>--}%
    %{--</g:if>--}%
    </div>



<div class="outer-center">

    <div class="middle-center">


        <div class="inner-center">
            <div id="spinner2" style="display:none; z-index: 10000 !important">
                <img src="${resource(dir: 'images', file: 'ajax-loader1.gif')}" alt="Spinner"
                     style="z-index: 10000 !important"/>
            </div>

<sec:ifNotGranted roles="ROLE_ADMIN">
    <g:if test="${OperationController.getPath('commandBar.enabled')?.toLowerCase() == 'yes' ? true : false}">
            <g:render template="/layouts/commandbar" model="[]"/>
        </g:if>
       </sec:ifNotGranted>

<sec:ifAnyGranted roles="ROLE_ADMIN">
    <g:render template="/layouts/commandbar" model="[]"/>
    </sec:ifAnyGranted>

            <div style="-moz-column-count: 3">

                <div id="hintArea" style="font-size: 10px; color: #255b17; font-style: italic;"></div>
            </div>

            <div id="logRegion"></div>

            <div id="logArea"></div>


            <div id="searchArea" class="nonPrintable">

            </div>

            <div id="centralArea" class="centralRegion">

                <g:render template='/reports/homepageSavedSearches'/>

            </div>

        </div>

        %{--<div class="inner-southInner" style="">--}%
%{----}%
        %{--</div>--}%



        %{--<div class="ui-layout-south">Inner South</div>--}%

    </div>

    %{--<div class="middle-west">Middle West</div>--}%
    %{----}%
    %{--<div class="middle-east">Middle East</div>--}%

</div>

%{--<div class="ui-layout-center">--}%

%{----}%
%{--</div>--}%