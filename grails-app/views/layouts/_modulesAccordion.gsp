
<%@ page import="ker.OperationController; mcs.parameters.JournalType; mcs.parameters.PlannerType; mcs.Book; mcs.Writing; app.Payment; app.IndicatorData; mcs.Journal; cmn.Setting; mcs.Planner; mcs.Task; mcs.Goal; app.Tag" %>

<div id="accordionModules"
     style="width: 95%; padding: 1px;">

<g:if test="${OperationController.getPath('goals.enabled')?.toLowerCase() == 'yes' ? true : false}">
    <h3><a>
        <span class="G-bkg"
              style="font-family: 'Lucida Console'; margin-right: 3px; padding-right: 2px; font-weight: bold;">G</span>
        ${OperationController.getPath('goals.label') ?: 'Goals'} <span
                class="moduleCount">
            ${Goal.count()}
        </span>
    </a>
    </h3>

    <div>
        <ul>
            <g:render template="/layouts/savedSearches" model="[entity: 'G']"/>
        </ul>
    </div>
</g:if>

<g:if test="${OperationController.getPath('tasks.enabled')?.toLowerCase() == 'yes' ? true : false}">

    <h3><a>
        <span class="T-bkg"
              style="font-family: 'Lucida Console'; margin-right: 3px; padding-right: 2px; font-weight: bold; font-size: 12px;">T</span>
        ${OperationController.getPath('tasks.label') ?: 'Tasks'}<span
                class="moduleCount">${Task.count()}</span></a></h3>

    <div>


                <g:link controller="task" action="expotTodotxt" target="_blank">
                    Export to Todo.txt format
                </g:link>

             <br/>

            <g:render template="/layouts/savedSearches" model="[entity: 'T']"/>

    </div>
</g:if>

<g:if test="${OperationController.getPath('planner.enabled')?.toLowerCase() == 'yes' ? true : false}">

    <h3><a>
        <span class="P-bkg"
              style="font-family: 'Lucida Console'; margin-right: 3px; padding-right: 2px; font-weight: bold;">P</span>
        ${OperationController.getPath('planner.label') ?: 'Planner'}<span
                class="moduleCount">${Planner.count()}</span>
    </a>
    </h3>

    <div>

        <ul>

            <g:render template="/layouts/savedSearches" model="[entity: 'P']"/>

        </ul>

    </div>

</g:if>


<g:if test="${OperationController.getPath('journal.enabled')?.toLowerCase() == 'yes' ? true : false}">
    <br/>
    <h3><a>
        <span class="J-bkg"
              style="font-family: 'Lucida Console'; margin-right: 3px; padding-right: 2px; font-weight: bold;">J</span>
        ${OperationController.getPath('journal.label') ?: 'Journal'}<span
                class="moduleCount">${Journal.count()}</span>
    </a>
    </h3>

    <div>

        <ul>
            <li>

                <a href="${createLink(controller: 'export', action: 'exportIcal', id: 'journal.ics')}"
                   target="_blank">
                    Export journal to iCal
                </a>

            </li>
            <g:render template="/layouts/savedSearches" model="[entity: 'J']"/>
        </ul>

    </div>

</g:if>

<g:if test="${OperationController.getPath('indicators.enabled')?.toLowerCase() == 'yes' ? true : false}">
    <h3>

        <a>

            <span class="K-bkg"
                  style="font-family: 'Lucida Console'; margin-right: 3px; padding-right: 2px; font-weight: bold;">I</span>
            ${OperationController.getPath('indicators.label') ?: 'Indicators'}<span
                class="moduleCount">${IndicatorData.count()}</span>
        </a>
    </h3>

    <div>

                <g:remoteLink controller="report" action="indicatorPanorama"
                              update="centralArea"
                              title="Update indicators">
                    Update indicators
                </g:remoteLink>


        <br/>

            <g:render template="/layouts/savedSearches" model="[entity: 'K']"/>

    </div>
</g:if>


<g:if test="${OperationController.getPath('payments.enabled')?.toLowerCase() == 'yes' ? true : false}">
    <h3><a><span class="Q-bkg"
                 style="font-family:  'Lucida Console'; margin-right: 3px; padding-right: 2px; font-weight: bold;">Q</span>
        ${OperationController.getPath('payments.label') ?: 'Payments'}
        <span
                class="moduleCount">${Payment.count()}</span>
    </a>
    </h3>


    <div>

        <ul>
            <li>
                <a onclick="jQuery('#searchArea').load('report/paymentCategories')">All categories</a>
            </li>

            <g:render template="/layouts/savedSearches" model="[entity: 'Q']"/>

        </ul>

    </div>
</g:if>


<g:if test="${OperationController.getPath('writings.enabled')?.toLowerCase() == 'yes' ? true : false}">
    <br/>
    <h3><a>
        <span class="W-bkg"
              style="font-family: 'Lucida Console'; margin-right: 3px; padding-right: 2px; font-weight: bold;">W</span>
        ${OperationController.getPath('writings.label') ?: 'Writings'}<span
                class="moduleCount">${Writing.count()}</span>
    </a></h3>

    <div>

        <ul>
            <li>

                <a onclick="jQuery('#logArea').load('export/generateForKindle')">
                    Generate wrt for kindle (one txt file per course)
                </a>
            </li>



            <li>
                <g:remoteLink controller="export" action="checkoutWritings"
                              update="centralArea"
                              title="Export all writings to text files">
                    Export all writings to text files
                </g:remoteLink>
                %{--todo--}%




            <li>
                <a href="${createLink(controller: 'export', action: 'exportWritingsToOneFile')}"
                   target="_blank">Writings 2 html (new page)</a>
            </li>

            <li>
                <g:render template="/layouts/savedSearches" model="[entity: 'W']"/>


            </li>


        </ul>

    </div>
</g:if>

<g:if test="${OperationController.getPath('notes.enabled')?.toLowerCase() == 'yes' ? true : false}">
    <h3>
        <a>
            <span class="N-bkg"
                  style="font-family: 'Lucida Console'; margin-right: 3px; padding-right: 2px; font-weight: bold;">N</span>
            ${OperationController.getPath('notes.label') ?: 'Notes'}
            <span class="moduleCount">${app.IndexCard.count()}</span>
        </a>
    </h3>

    <div>
        <ul>
            <g:render template="/layouts/savedSearches" model="[entity: 'N']"/>
        </ul>

    </div>
</g:if>
<br/>

<g:if test="${OperationController.getPath('resources.enabled')?.toLowerCase() == 'yes' ? true : false}">
    <h3><a>
        <span class="R-bkg"
              style="font-family: 'Lucida Console'; margin-right: 3px; padding-right: 2px; font-weight: bold;">R</span>
        ${OperationController.getPath('resources.label') ?: 'Resources'}
        <span class="moduleCount">${mcs.Book.executeQuery("select count (*) from Book")[0]}
        </span>
    </a></h3>

    <div>

        <ul>

            <li><a onclick="jQuery('#centralArea').load('report/duplicateIsbnBooks')">Books with duplication ISBN</a>
            </li>



            <li>
                <a onclick="jQuery('#centralArea').load('export/exportAllBooksByCourseAsLinks')"
                   title="generates link.bat">
                    Export hard links scripts todo
                </a>
            </li>
            <li>
                <g:remoteLink controller="operation" action="updateAllWithoutTitle" update="notificationArea">
                    Update all ISBNs of books without title (${Book.countByIsbnIsNotNullAndTitleIsNull()})
                todo
                </g:remoteLink>

            </li>
            <li>
                <g:remoteLink controller="operation" action="updateAllBibEntries" update="notificationArea">
                    Update all BibTex entries (${Book.countByIsbnIsNotNullAndBibEntryIsNull()})
                </g:remoteLink>

            </li>

            <li>
                <a href="export/exportAllBooksToText" target="_blank"
                   title="">
                    Show books list in text
                </a>
            </li>


            %{--<li><a onclick="jQuery('#centralArea').load('book/report/notitle')">No title books</a>--}%
            %{--</li>--}%

            %{--<li><a onclick="jQuery('#centralArea').load('book/report/isbnNoTitle')">ISBN  without title</a>--}%
            %{--</li>--}%
            <g:render template="/layouts/savedSearches" model="[entity: 'R']"/>
        </ul>

    </div>
</g:if>

<g:if test="${OperationController.getPath('excerpts.enabled')?.toLowerCase() == 'yes' ? true : false}">
    <h3><a>
        <span class="E-bkg"
              style="font-family: 'Lucida Console'; margin-right: 3px; padding-right: 2px; font-weight: bold;">E</span>
        ${OperationController.getPath('excerpts.label') ?: 'Excerpts'} <span class="moduleCount">${mcs.Excerpt.countByDeletedOnIsNull()}
        </span>
    </a>
    </h3>

    <div>
       
            <g:render template="/layouts/savedSearches" model="[entity: 'E']"/>

        
    </div>

</g:if>

<g:if test="${OperationController.getPath('contacts.enabled')?.toLowerCase() == 'yes' ? true : false}">
    <h3>
        <a>
            <span class="S-bkg"
                  style="font-family: 'Lucida Console'; margin-right: 3px; padding-right: 2px; font-weight: bold;">S</span>
            ${OperationController.getPath('contacts.label') ?: 'Contacts'}<span
                class="moduleCount">${app.Contact.countByDeletedOnIsNull()}</span>
        </a>
    </h3>

    <div>
        <ul>

            <g:render template="/layouts/savedSearches" model="[entity: 'U']"/>
        </ul>

    </div>
    <br/>
</g:if>

</div>
