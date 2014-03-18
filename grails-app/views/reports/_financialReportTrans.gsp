<%@ page import="app.Payment;app.PaymentCategory; mcs.Department; mcs.Planner; mcs.Journal" %>
<style type="text/css">
#jpCalendar table th {
    font-weight: bold !important;
    background: #7ba1b9;
    color: #ffffff;
}

#jpCalendar table td {
    vertical-align: top;
}
</style>



<h2>trans report</h2>

<div id="trans-report">
    <table border="1" style="width: 98%; border: #496779; border-collapse: collapse;">

        <thead>
        <th></th>
        <g:each in="${(startDate..endDate)}" var="d">
            <th>${mcs.Utils.toWeekDate(d)}</th>
        </g:each>
        </thead>

<g:each in="${PaymentCategory.findAllByCategory('trans', [sort: 'code'])}" var="d">
        <tr>
            <td>
              ${d.code}
            </td>
            <g:each in="${(startDate..endDate)}" var="date">
                <td>

                    ${Payment.executeQuery('select sum(amount) from Payment where category = ? and date(date) = ? order by date desc',
                            [d, date])[0]}

                </td>
            </g:each>
        </tr>
    </g:each>

    </table>

</div>