%{--
  - Copyright (c) 2014. Mohamad F. Fakih (mail@mfakih.org)
  -
  - This program is free software: you can redistribute it and/or modify
  - it under the terms of the GNU General Public License as published by
  - the Free Software Foundation, either version 3 of the License, or
  - (at your option) any later version.
  -
  - This program is distributed in the hope that it will be useful,
  - but WITHOUT ANY WARRANTY; without even the implied warranty of
  - MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  - GNU General Public License for more details.
  -
  - You should have received a copy of the GNU General Public License
  - along with this program.  If not, see <http://www.gnu.org/licenses/>
  --}%

<%@ page import="app.Indicator; mcs.Goal; mcs.Task; mcs.Journal; mcs.Writing; app.IndexCard;ys.wikiparser.WikiParser; mcs.Excerpt; mcs.Book; mcs.Course;" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

    %{--<meta name="layout" content="main"/>--}%
    <title>${record.entityCode()} ${record?.toString()}</title>


    <link rel="shortcut icon" href="${resource(dir: 'images/icons', file: 'record.ico')}" type="image/png"/>





    <r:require modules="application"/>
    <r:require module="fileuploader"/>
    <r:require modules="jquery"/>
    <r:require modules="jquery-ui"/>


    <r:layoutResources/>


    <link rel="stylesheet" href="${resource(dir: 'css', file: 'uploader.css')}"/>

    <link rel="stylesheet" href="${resource(dir: 'css', file: 'jquery-ui-1.8.22.custom.css')}"/>
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'jquery.autocomplete.css')}"/>


    %{--<uploader:head css="${resource(dir: 'css', file: 'uploader.css')}"/>--}%

    %{----}%

    %{--<uploader:head/>--}%


    <link rel="stylesheet" href="${resource(dir: 'css', file: 'jquery.continuousCalendar.css')}"/>



    %{--<script type="text/javascript" src="${resource(dir: 'js', file: 'jquery/jquery-1.3.2.min.js')}"></script>--}%



    <script type="text/javascript" src="${resource(dir: 'js', file: 'DateFormat.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'DateLocale.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'DateRange.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'DateTime.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.continuousCalendar-latest.js')}"></script>

    %{--<script type="text/javascript" src="${resource(dir: 'js', file: 'fileuploader.js')}"></script>--}%
    %{--<script type="text/javascript" src="${resource(dir: 'css', file: 'uploader.css')}"></script>--}%


    <script type="text/javascript" src="${resource(dir: 'js', file: 'raphael-min.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'morris.js')}"></script>


    <link rel="stylesheet" href="${resource(dir: 'css', file: 'fg.menu.css')}"/>

    <script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'ui.achtung-min.js')}"></script>
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'ui.achtung-min.css')}"/>

    %{--<script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'fullcalendar.min.js')}"></script>--}%
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'morris.css')}"/>

    <link rel="stylesheet" href="${resource(dir: 'css', file: 'main.css')}"/>


    <script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'fg.menu.js')}"></script>

    %{--<script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'jquery.jeditable.mini.js')}"></script>--}%
    <script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'jquery.blockUI.js')}"></script>



    <script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'jquery.autocomplete.min.js')}"></script>

    %{--<script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'jquery.relatedselects.min.js')}"></script>--}%

    %{--<script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'shortcut.js')}"></script>--}%
    <script type="text/javascript" src="${resource(dir: 'js', file: 'mousetrap.min.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'mousetrap-global-bind.min.js')}"></script>



    <script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.tablednd_0_5.js')}"></script>


    <script type=text/javascript>

        jQuery(document).ready(function () {




            });

    </script>



</head>

<body style="margin:5px; background: none; color: #111111">



<g:if test="${record.entityCode() == 'M'}">

<div style="-moz-column-count: 1">


    <g:each in="${mcs.Writing.findAllByCourse(record, [sort: 'orderInCourse', order: 'asc'])}"
            var="c">

        <g:link controller="page" action="record" target="_blank"
                params="${[id: c.id, entityCode: c.entityCode()]}">


            <div style="margin: 10px;font-family: Trebuchet MS, Verdana, Geneva, Arial, Helvetica, sans-serif; padding: 4px; font-size: 18px">
        
       #${c.orderInCourse} W<sup>${c.id}</sup> <b>${c.summary}</b>
        </div>
        </g:link>

        <table border="1" style="border-collapse: collapse; width: 100%">
        <tr>
            <td style="width: 50%">

                <div style="font-size: 12px; line-height: 15px;text-align: justify">
                    ${ys.wikiparser.WikiParser.renderXHTML(c.description)?.replaceAll('\n', '<br/>')?.decodeHTML()}

                </div>

            </td>
           <td>

               <br/>
               <div style="font-size: 12px; line-height: 15px;text-align: justify">
                   ${ys.wikiparser.WikiParser.renderXHTML(c.shortDescription)?.replaceAll('\n', '<br/>')?.decodeHTML()}

               </div>


           </td>
        </tr>

        </table>



        
    <g:each in="${app.IndexCard.findAllByWriting(c, [sort: 'orderInWriting', order: 'asc'])}"
            var="i">
            <div style="font-size: 12px; line-height: 15px;">
                <g:link controller="page" action="record" target="_blank"
                        params="${[id: i.id, entityCode: i.entityCode()]}">

            <div style="margin: 10px;font-family: Trebuchet MS, Verdana, Geneva, Arial, Helvetica, sans-serif; padding: 4px;font-size: 14px ">



            #${i.orderInWriting} C<sup>${i.id}</sup> <b>${i.summary}</b>
         </div>

                </g:link>

                <table border="1" style="border-collapse: collapse; width: 100%">
                    <tr>
                        <td style="margin-left: 10px; width: 50%">
                             <div style="font-size: 12px; line-height: 15px;text-align: justify">
                                ${ys.wikiparser.WikiParser.renderXHTML(i.description)?.replaceAll('\n', '<br/>')?.decodeHTML()}
                            </div>

                        </td>
                        <td>

                            <br/>
                            <div style="font-size: 12px; line-height: 15px;text-align: justify">
                                ${i.shortDescription?.replaceAll('\n', '<br/>')}
                           </div>


                        </td>
                    </tr>

                </table>



        </div>
    </g:each>

    </g:each>
    </div>

</g:if>






<g:if test="${record.entityCode() == 'W'}">
    <g:each in="${app.IndexCard.findAllByWriting(Writing.get(record.id), [sort: 'orderInWriting', order: 'asc'])}"
            var="c">
        <g:render template="/gTemplates/box" model="[record: c]"/>
    </g:each>
</g:if>

<g:if test="${record.entityCode() == 'B'}">
    <g:each in="${app.IndexCard.findAllByBook(Book.get(record.id), [sort: 'orderInBook', order: 'asc'])}" var="c">
        <g:render template="/gTemplates/box" model="[record: c]"/>
    </g:each>
</g:if>
</div>

    <div id="notificationArea"></div>


<r:layoutResources/>

</body>

</html>
