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

        <div id="accordion1" class="basic">

			<h3><a href="#">Section 1</a></h3>
			<div>
				<h5>West Pane</h5>
				<p>Mauris mauris ante, blandit et, ultrices a, suscipit eget, quam.
					Integer ut neque. Vivamus nisi metus, molestie vel, gravida in, condimentum sit amet, nunc.</p>
				<p>Nam a nibh. Donec suscipit eros. Nam mi. Proin viverra leo ut odio. Curabitur malesuada.
					Vestibulum a velit eu ante scelerisque vulputate.</p>
			</div>

			<h3><a href="#">Section 2</a></h3>
			<div>
				<h5>Sed Non Urna</h5>
				<p>Donec et ante. Phasellus eu ligula. Vestibulum sit amet purus.
					Vivamus hendrerit, dolor at aliquet laoreet, mauris turpis porttitor velit,
					faucibus interdum tellus libero ac justo.</p>
				<p>Vivamus non quam. In suscipit faucibus urna.</p>
			</div>
			</div>
        <div id="3rdPanel">


            <h1>Welcome to Pomegranate</h1>
            <div style="padding: 3px; font-size: 13px; font-family: tahoma; margin: 5px; line-height: 20px">
${htmlContent}

</div>
        </div>
        %{--<g:if test="${ker.OperationController.getPath('twoPanels') == 'on'}">--}%
        %{--<g:render template="/layouts/east"/>--}%
    %{--</g:if>--}%
    </div>


<div class="ui-layout-center" style="display: none;">


    <div id="spinner2" style="display:none; z-index: 10000 !important">
                <img src="${resource(dir: 'images', file: 'ajax-loader1.gif')}" alt="Spinner2"
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


