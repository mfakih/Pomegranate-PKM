<%@ page import="cmn.Setting; mcs.Course; mcs.Journal; mcs.Planner; app.IndexCard; mcs.Task; ker.OperationController" %>
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

        <div id="accordionEast" class="basic">

			<h3><a href="#">Details panel</a></h3>
			   <div id="3rdPanel">

			</div>

			<h3><a href="#">Tags</a></h3>
			<div id='tagsPanel'>

                </div>
<g:if test="${Setting.findByName('contacts.enabled')?.value ==  'yes'}">
	<h3><a href="#">Contacts</a></h3>
			<div id='contactsPanel'>

                </div>
           </g:if>
<g:if test="${Setting.findByName('dashboard.enabled')?.value ==  'yes'}">
            	<h3><a href="#">Dashboard</a></h3>
			<div>
                <h1>Active courses</h1>

                <g:each in="${Course.findAllByBookmarked(true)}" var="c">
                    <b>${c.code}</b>
                    ${c.summary}
                    <br/>
                </g:each>

                <h1>Last 24 hours' records</h1>

                ${Task.countByDateCreatedGreaterThan(new Date() - 1)} new tasks <br/>
                ${Task.countByCompletedOnGreaterThan(new Date() - 1)} completed tasks <br/>
                ${IndexCard.countByDateCreatedGreaterThan(new Date() - 1)} notes <br/>
                ${Journal.countByDateCreatedGreaterThan(new Date() - 1)} journal<br/>
                ${Planner.countByDateCreatedGreaterThan(new Date() - 1)} planner
                   <h1>Last 7 days' records</h1>

                ${Task.countByDateCreatedGreaterThan(new Date() - 7)} new tasks <br/>
                ${Task.countByCompletedOnGreaterThan(new Date() - 7)} completed tasks <br/>
                ${IndexCard.countByDateCreatedGreaterThan(new Date() - 7)} notes <br/>
                ${Journal.countByDateCreatedGreaterThan(new Date() - 7)} journal<br/>
                ${Planner.countByDateCreatedGreaterThan(new Date() - 7)} planner






                <h1>Shortcut Keys</h1>




                <li><b>ESC</b> focus</li>
                <li><b>F10</b> xcd note add</li>
                <li><b>Shift+F5</b> hide central region</li>
                <li><b>Ctrl + alt + n</b> next</li>
                <li><b>p</b> previous</li>
                <li><b>s</b> selected</li>
                <li><b>F9</b> toggle navigation menu</li>




                <div style="padding: 3px; font-size: 13px; font-family: tahoma; margin: 5px; line-height: 20px">
                    <!--{htmlContent}-->

                </div>
			</div>
    </g:if>

<h3><a href="#">Sandbox</a></h3>
<div id='sandboxPanel'>

        </div>

</div>
        %{--<g:if test="${ker.OperationController.getPath('twoPanels') == 'on'}">--}%
        %{--<g:render template="/layouts/east"/>--}%
    %{--</g:if>--}%
    </div>


<div class="ui-layout-center" style="display: none;">
	<div class="ui-layout-content ui-widget-content">


    <div id="spinner2" style="display:none; z-index: 10000 !important">
                <img src="${resource(dir: 'images/spinners', file: 'pmg-grain.gif')}" alt="Spinner2"
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

                <div id="hintArea" style="font-size: 10px; color: #255b17; font-style: italic; height: 20px;"></div>
            </div>

            <div id="logRegion"></div>

            <div id="logArea"></div>


            <div id="searchArea" class="nonPrintable">

            </div>

            <div id="centralArea" class="centralRegion">

                %{--<g:select name="username" id="username"--}%
                          %{--data-type="select" data-pk="sami" data-url="operation/autoCompleteTagsJSON" data-title="Enter username"--}%
                          %{--from="['sami', 'dani', 'asdfsa']" value="sami"></g:select>--}%





                %{--<g:textField id="test123" name="test"--}%
                             %{--style="z-index: 10000" value=""/>--}%
                %{--<script>--}%
                    %{--jQuery("#test123").autocomplete({appendTo: ".autoCompleterItem",source: '/pkm/operation/autoCompleteTags'})--}%
%{--//                    this.options.appendTo = ".autoCompleterItem";--}%
%{--//                </script>--}%

                <!--g:render template='/reports/homepageSavedSearches'/-->

            </div>

        </div>
    </div>


