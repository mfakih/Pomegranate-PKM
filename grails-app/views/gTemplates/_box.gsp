<%@ page import="java.text.DecimalFormat; mcs.Goal; org.apache.commons.lang.StringUtils; mcs.Writing; mcs.Task; mcs.Planner" %>


<div class="" style="margin-bottom: 5px; margin-top: 5px;max-width: 550px;">
    <g:if test="${record}">
        <table width="99%;" border="0"
               style="background: #F8FBFE; border-collapse: collapse; -moz-border-radius: 6px; margin: 2px; border: 1px solid #cccccc; padding-bottom: 2px;">

            %{--<!--Id: ${plannerInstance.id} -->--}%

            <tr style="" class="${'GTP'.contains(record.entityCode()) ? 'workStatus-' + record.status?.code : ''}">

                <td style="width: 100%; font-size: 12px;padding: 2px;">

                    <div class="${record.entityCode()}-bkg ID-bkg" style="display: inline">
                        <g:link controller="page" action="record" target="_blank"
                                params="${[id: record.id, entityCode: record.entityCode()]}"
                                title="${record?.description}">
                            ${record.entityCode()}
                        </g:link>
                    </div>

                    <sup>${record.priority}</sup>

                    <g:if test="${'RE'.contains(record.entityCode())}">
                        <sup>${record.orderInCourse}</sup>
                    </g:if>


                    <g:link controller="page" action="record" target="_blank"
                            params="${[id: record.id, entityCode: record.entityCode()]}"
                            title="${record?.description}">

                        <span style="color: #003399;">

                            <g:if test="${'G'.contains(record.entityCode())}">
                                <i style="font-size: smaller">${record?.type?.code} ${record.department?.code}</i>&nbsp;
                            </g:if>
                            <g:if test="${'T'.contains(record.entityCode())}">
                                <i style="font-size: smaller">${record?.location?.code} ${record?.course?.code} ${record.department?.code}</i>&nbsp;
                                <sup>${record.plannedDuration ? record.plannedDuration + "''" : ''}</sup>
                            </g:if>
                            <g:if test="${'P'.contains(record.entityCode())}">
                                <i style="font-size: smaller">${record?.type?.code} ${record.status?.code}</i>&nbsp;
                            </g:if>
                            <g:if test="${'J'.contains(record.entityCode())}">
                                <i style="font-size: smaller">${record?.type?.code} ${record.department?.code}</i>&nbsp;
                            </g:if>
                            <g:if test="${'W'.contains(record.entityCode())}">

                                <i style="font-size: smaller">${record?.type?.code} ${record.department?.code}</i>&nbsp;
                            </g:if>
                            <g:if test="${'E'.contains(record.entityCode())}">
                                <i style="font-size: smaller">
                                    B-${record?.book?.id}
                                    ${record?.book?.author},
                                    ${record?.book?.title ?: record?.book?.legacyTitle} ${record?.book?.edition}
                                    (${record?.book?.publisher},
                                    ${record?.book?.publicationDate})
                                </i>&nbsp;
                                <br/>
                                <i style="font-size: smaller">${record.class.declaredFields.name.contains('type') ? record?.type?.code: ''} ${record.class.declaredFields.name.contains('department') ? record.department?.code: ''}</i>&nbsp;
                            </g:if>
                        </span>


                        <g:if test="${'P'.contains(record.entityCode()) && record.task}">
                            <span title="${record?.summary}">${record.task?.summary}</span>
                        </g:if>
                        <g:elseif test="${'N'.contains(record.entityCode())}">
                            ${record?.orderInWriting ? '#' + record?.orderInWriting + ' ' : ''} ${record?.summary}
                        </g:elseif>
                        <g:elseif test="${'R'.contains(record.entityCode())}">

                            ${record?.title ?: record?.legacyTitle}
                            <i>${record?.author}</i>

                        </g:elseif>

                        <g:elseif test="${'E'.contains(record.entityCode())}">

                            <span style="color: gray">${record?.book?.title ?: record?.book?.legacyTitle}</span>
                            <u>${record.chapters}</u>
                            <i>${record?.summary}</i>
                        </g:elseif>

                        <g:else>
                            ${record?.summary}
                        </g:else>

                        <g:if test="${'C'.contains(record.entityCode())}">
                            <b>${record.code}
                                ${record.code}</b>
                            ${record.summary}
                        </g:if>

                        <br/>
                    </g:link>
                <!--div style="line-height: 20px;">
                    ${record.description?.encodeAsHTML()?.replaceAll('\n', '<br/>')}
                    </div-->

                </td>

            </tr>

            <tr>
                <td colspan="2" class="box-priority-${record.priority}" style="height: 1px;">

                </td>
            </tr>
        </table>
    </g:if>
</div>