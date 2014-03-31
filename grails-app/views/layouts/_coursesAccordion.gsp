<%@ page import="org.apache.commons.lang.StringUtils;  mcs.Course; mcs.Department; ker.OperationController; mcs.parameters.JournalType; mcs.parameters.PlannerType; mcs.Book; mcs.Writing; app.Payment; app.IndicatorData; mcs.Journal; cmn.Setting; mcs.Planner; mcs.Task; mcs.Goal; app.Tag" %>

<div id="accordionCourses"
     style="width: 95%; padding: 1px;">


    <g:if  test="${mcs.Department.count() == 0}">
        <h1>There are no departments yet.</h1>
    </g:if>


    <g:each in="${mcs.Department.list([sort: 'code'])}" var="d">

        <h3 class="bowseTab">
            %{--<g:remoteLink controller="report" action="departmentCourses"--}%
            %{--update="centralArea" params="[id: d.id]"--}%
            %{--title="Actions">--}%
            %{--<span style="padding: 1px;">--}%



            <a>

                ${d.summary}
                <span class="moduleCount">

                    <b> ${d.code}  </b> (${d.courses.size()})
                </span>
                %{--<span class="I-bkg" style=" float: right;"--}%
                %{--style="font-family: 'Lucida Console'; margin-right: 3px; padding-right: 2px; font-weight: bold;">--}%
                %{--</span>--}%

            </a>

        </h3>


        <div>
            <ul style="padding-left: 0">
                <g:each in="${Course.findAllByDepartment(Department.get(d.id), [sort: 'code', order: 'asc'])}"
                        var="t">
                    <li style="list-style-type: none">
                        <g:remoteLink controller="generics" action="recordsByCourse" id="${t.id}"
                                      update="centralArea">
                            <b>${t.numberCode}</b>
                            ${StringUtils.abbreviate(t.summary, 26)}
                            <sup>
                                <b>${t.code != t.numberCode.toString() ? t.code : ''}</b>

                            </sup>
                        </g:remoteLink>
                    </li>
                </g:each>
            </ul>
        </div>

    </g:each>

</div>
