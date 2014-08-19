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

<%@ page import="ker.OperationController; cmn.Setting" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
%{--<meta name="layout" content="main"/>--}%

<title>${OperationController.getPath('app.name') ?: 'Pomegranate PKM'} v<g:meta name="app.version"/></title>


<link rel="shortcut icon" href="${resource(dir: 'images', file: 'favicon-32px.png')}" type="image/png"/>




<link rel="stylesheet" href="${resource(dir: 'css', file: 'uploader.css')}"/>


<link rel="stylesheet" href="${resource(dir: 'css', file: 'jquery-ui-1.8.22.custom.css')}"/>
%{--<link rel="stylesheet" href="${resource(dir: 'css', file: 'jquery-ui-1.10.4.custom.css')}"/>--}%
<link rel="stylesheet" href="${resource(dir: 'css', file: 'main.css')}"/>
<link rel="stylesheet" href="${resource(dir: 'css', file: 'layout-mine.css')}"/>
<link rel="stylesheet" href="${resource(dir: 'css', file: 'personalization.css')}"/>
%{--<link rel="stylesheet" href="${resource(dir: 'css', file: 'jquery.autocomplete.css')}"/>--}%



<link rel="stylesheet" href="${resource(dir: 'css', file: 'fg.menu.css')}"/>
%{--<link rel="stylesheet" href="${resource(dir: 'css', file: 'layout-mine.css')}"/>--}%

%{--<script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'ui.achtung-min.js')}"></script>--}%
%{--<link rel="stylesheet" href="${resource(dir: 'css', file: 'ui.achtung-min.css')}"/>--}%


%{--<link rel="stylesheet" href="${resource(dir: 'css', file: 'prettyPhoto.css')}"/>--}%


<script type="text/javascript" src="${resource(dir: 'js', file: 'jquery-1.11.0_min.js')}"></script>

<script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.address-1.5.min.js?autoUpdate=0')}"></script>

<script type="text/javascript" src="${resource(dir: 'js', file: 'jquery-ui-1.10.4.custom.min.js')}"></script>


%{--<link rel="stylesheet" href="${resource(dir: 'css', file: 'select2.css')}"/>--}%
%{--<script type="text/javascript" src="${resource(dir: 'js', file: 'select2.min.js')}"></script>--}%
<link rel="stylesheet" href="${resource(dir: 'css', file: 'jqueryui-editable.css')}"/>
<script type="text/javascript" src="${resource(dir: 'js', file: 'jqueryui-editable.min.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js', file: 'typeahead.bundle.js')}"></script>
%{--<script type="text/javascript" src="${resource(dir: 'js', file: 'fileuploader.js')}"></script>--}%
%{--<script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.flipcountdown.js')}"></script>--}%
<script type="text/javascript" src="${resource(dir: 'js', file: 'mousetrap.min.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js', file: 'mousetrap-global-bind.min.js')}"></script>



<script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.layout-latest_min.js')}"></script>

<script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.purr.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js', file: 'fg.menu.js')}"></script>

%{--<link rel="stylesheet" href="${resource(dir: 'css/minimal', file: 'minimal.css')}"/>--}%
%{--<link rel="stylesheet" href="${resource(dir: 'css/minimal', file: 'grey.css')}"/>--}%
<link rel="stylesheet" href="${resource(dir: 'css', file: 'jquery.continuousCalendar.css')}"/>


%{--<script type="text/javascript" src="${resource(dir: 'js', file: 'icheck.js')}"></script>--}%
<script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.continuousCalendar-latest.js')}"></script>

%{--<script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.prettyPhoto.js')}"></script>--}%
<script type="text/javascript" src="${resource(dir: 'js', file: 'raphael-min.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js', file: 'morris.js')}"></script>


%{--<r:layoutResources/>--}%

%{--<link rel="stylesheet" href="${resource(dir: 'css', file: 'jquery-ui-1.8.22.custom.css')}"/>--}%


<script type="text/javascript">

//    $.address.state('/pkm/')
    $.address.externalChange(function (event) {
        // do something depending on the event.value property, e.g.
        // $('#content').load(event.value + '.xml');
       // console.log('fired ' + event.value)
        if(event.value != '/')
        jQuery('#centralArea').load(event.value)
    });

/**
 *    UI Layout Callback: resizePaneAccordions
 *
 *    This callback is used when a layout-pane contains 1 or more accordions
 *    - whether the accordion a child of the pane or is nested within other elements
 *    Assign this callback to the pane.onresize event:
 *
 *    SAMPLE:
 *    < jQuery UI 1.9: $("#elem").tabs({ show: $.layout.callbacks.resizePaneAccordions });
 *    > jQuery UI 1.9: $("#elem").tabs({ activate: $.layout.callbacks.resizePaneAccordions });
 *    $("body").layout({ center__onresize: $.layout.callbacks.resizePaneAccordions });
 *
 *    Version:    1.2 - 2013-01-12
 *    Author:        Kevin Dalman (kevin.dalman@gmail.com)
 */
;
(function ($) {
    var _ = $.layout;

// make sure the callbacks branch exists
    if (!_.callbacks) _.callbacks = {};

    _.callbacks.resizePaneAccordions = function (x, ui) {
        // may be called EITHER from layout-pane.onresize OR tabs.show
        var $P = ui.jquery ? ui : $(ui.newPanel || ui.panel);
        // find all VISIBLE accordions inside this pane and resize them
        $P.find(".ui-accordion:visible").each(function () {
            var $E = $(this);
            if ($E.data("accordion"))		// jQuery < 1.9
                $E.accordion("resize");
            if ($E.data("ui-accordion"))	// jQuery >= 1.9
                $E.accordion("refresh");
        });
    };
})(jQuery);






    jQuery(document).ready(function () {

        for (var i = 0; i < localStorage.length; i++) {
            // do something with localStorage.getItem(localStorage.key(i));
            var key = localStorage.key(i)
            var value = localStorage[key]
            console.log('key ' + key + 'value' + value)
//            if ((typeof value == 'string' || value instanceof String) && !value.contains('datum'))
//            if (value.contains('pkm-'))
//            document.getElementById('commandHistory').options.add(new Option(value, localStorage.key(i)))
        }




        var myLayout = $('body').layout({
            west__size: 230,
            east__size: 320,
            // RESIZE Accordion widget when panes resize
           west__onresize: $.layout.callbacks.resizePaneAccordions,
            east__onresize: $.layout.callbacks.resizePaneAccordions,
//            onresize: $.layout.callbacks.resizePaneAccordions,
            north__closable: false, north__spacing_closed: 0		// big resizer-bar when open (zero height)
            , north__resizable: false	// OVERRIDE the pane-default of 'resizable=true'
            , south__resizable: false	// OVERRIDE the pane-default of 'resizable=true'
            , south__spacing_open: 0		// no resizer-bar when open (zero height)
            , south__spacing_closed: 0		// big resizer-bar when open (zero height)

            , east__spacing_open: 5		// no resizer-bar when open (zero height)
            , east__spacing_closed: 15		// big resizer-bar when open (zero height)
            , west__spacing_open: 5		// no resizer-bar when open (zero height)
            , west__spacing_closed: 15		// big resizer-bar when open (zero height)


        });


        $.fn.editable.defaults.mode = 'inline';
        $.fn.editable.defaults.showbuttons = false;

        jQuery('.fg-button').hover(
                function () {
                    jQuery(this).removeClass('ui-state-default').addClass('ui-state-focus');
                },
                function () {
                    jQuery(this).removeClass('ui-state-focus').addClass('ui-state-default');
                }
        );

        var matched, browser;

        jQuery.uaMatch = function (ua) {
            ua = ua.toLowerCase();

            var match = /(chrome)[ \/]([\w.]+)/.exec(ua) ||
                    /(webkit)[ \/]([\w.]+)/.exec(ua) ||
                    /(opera)(?:.*version|)[ \/]([\w.]+)/.exec(ua) ||
                    /(msie) ([\w.]+)/.exec(ua) ||
                    ua.indexOf("compatible") < 0 && /(mozilla)(?:.*? rv:([\w.]+)|)/.exec(ua) ||
                    [];

            return {
                browser: match[ 1 ] || "",
                version: match[ 2 ] || "0"
            };
        };

        matched = jQuery.uaMatch(navigator.userAgent);
        browser = {};

        if (matched.browser) {
            browser[ matched.browser ] = true;
            browser.version = matched.version;
        }

// Chrome is Webkit, but Webkit is also Safari.
        if (browser.chrome) {
            browser.webkit = true;
        } else if (browser.webkit) {
            browser.safari = true;
        }

        jQuery.browser = browser;

        // this layout could be created with NO OPTIONS - but showing some here just as a sample...
        // myLayout = jQuery('body').layout(); -- syntax with No Options

//        jQuery('input').iCheck({
//            checkboxClass: 'icheckbox_minimal-grey',
//            radioClass: 'iradio_minimal-grey',
//            increaseArea: '-20%' // optional
//        });

//        jQuery('#searchForm').load('generics/hqlSearchForm/T')

        jQuery('#centralArea').load('generics/recentRecords')

//        jQuery('#quickAddTextField').select();
//        jQuery('#quickAddTextField').focus();

        jQuery('#range_start').val('')
        jQuery('#range_end').val('')

        jQuery("#dateRange1").continuousCalendar({"selectToday": false,
            "weeksBefore": "40",//"1/1/2012",
            "weeksAfter": "8",
            "minimumRange": "-1",
            %{--"disabledDates": "${filledInDates}",--}%
            "disabledDatesMy": "${[]}",
            "fadeOutDuration": "0",
            isPopup: false,
            callback: function () {
                jQuery('#centralArea').load('${createLink(controller: 'report', action: 'saveDateSelection')}?date1=' +
                        jQuery('#range_start').val() + '&date2='
                        + jQuery('#range_end').val())//      + '&level=d')
            }})


        // ACCORDION - in the West pane
        $("#accordionEast").accordion({
            heightStyle: "fill",
            header: "h3",
            event: "click",
            active: 3,
            collapsible: true,
            icons: {
                header: "ui-icon-circle-arrow-e",
                headerSelected: "ui-icon-circle-arrow-s"
            }

        });
        $("#accordionWest").accordion({
            heightStyle: "fill",
            fillSpace: true,
            header: "h4",
            event: "click",
            active: 2,
            collapsible: true,
            icons: {
                header: "ui-icon-circle-arrow-e",
                headerSelected: "ui-icon-circle-arrow-s"
            }

        });


        Mousetrap.bindGlobal('esc', function (e) {
//            jQuery("html, body").animate({ scrollTop: 0 }, "fast");
            jQuery('#centralArea').html('');
            jQuery('#quickAddTextFieldBottomTop').focus();
            jQuery('#quickAddTextFieldBottomTop').select();
//            jQuery('#quickAddTextField').scrollTop(0);
        });

//        Mousetrap.bindGlobal('esc', function (e) {
//
////            jQuery('#centralArea').html('');
////            jQuery('#quickAddTextField').focus();
////            jQuery('#quickAddTextField').select();
//            jQuery('#quickAddRecordTextArea').select().focus();
//
//        });

        Mousetrap.bindGlobal('f6', function (e) {
            jQuery('#centralArea').html('');
            jQuery('#quickAddTextField').focus();
            jQuery('#quickAddTextField').select();

        });

        Mousetrap.bindGlobal('f2', function (e) {

            jQuery('#quickAddRecordTextArea').select().focus();

        });

        var collapsed = false;
        Mousetrap.bindGlobal('f9', function (e) {
            if (!collapsed) {
                jQuery('#topRegion').addClass('navHidden');
                jQuery('#navMenu').addClass('navHidden');
                jQuery('#southRegion').addClass('navHidden');
                collapsed = true
            }
            else {
                jQuery('#topRegion').removeClass('navHidden');
                jQuery('#navMenu').removeClass('navHidden');
                jQuery('#southRegion').removeClass('navHidden');
                collapsed = false
            }

        });

        Mousetrap.bind('n', function (e) {
            jQuery('.nextLink').click()
        });

        Mousetrap.bind('ctrl+s', function (e) {
            jQuery('#quickAddRecordSubmit').click()
        });

        Mousetrap.bind('p', function (e) {
            jQuery('.prevLink').click()
        });

        /*
         For modifier keys you can use shift, ctrl, alt, option, meta, and command.

         Other special keys are backspace, tab, enter, return, capslock, esc,
         escape, space, pageup, pagedown, end, home, left, up, right, down, ins, and del.

         Any other key you should be able to reference by name like a, /, $, *, or =.

         */

        jQuery("#quickAddTextField").keypress(function (e) {
            if (e.keyCode == 13 && e.shiftKey) {
                jQuery('#quickAddXcdSubmit').click();
                e.preventDefault();
//                   jQuery('#quickAddTextField').addClass('shiftEnterPressed');
//                   jQuery("#quickAddTextField").fadeOut("fast", function () {
                jQuery('#quickAddTextField').addClass('shiftEnterPressed');
                setTimeout(dosth, 400);
            }
        });
        function dosth() {
            jQuery('#quickAddTextField').removeClass('shiftEnterPressed')
        }

        Mousetrap.bindGlobal('f2', function (e) {
//      jQuery('#quickAddXcdSubmit').click();
            jQuery('#quickAddXcdField').select();
            jQuery('#quickAddXcdField').focus();
        });

        //Todo how to disable formRemote submission
        // document.forms.quickAddForm['submit'].disabled = true;


        jQuery(window).bind('beforeunload', function () {
            return 'Are you sure you want to leave the application?';
        });


        jQuery.ajaxSetup({
            beforeSend: function () {
                $('#spinner2').show();
            },
            complete: function () {
                $('#spinner2').hide();
            }
            ,
            success: function () {
                $('#spinner2').hide();
            }


        });

        jQuery(document).ajaxComplete(function () {
            $('#spinner2').hide();
        });

       jQuery(document).ajaxStop(function () {
            $('#spinner2').hide();
        });
   jQuery(document).ajaxSuccess(function () {
            $('#spinner2').hide();
        });

        $(document).ajaxError(function () {
            $('#spinner2').hide();
        });

    });

</script>

</head>

<body>



<!--browser:isIExplorer todo-->


<browser:isChrome>
    <g:render template="/page/regions" model="[htmlContent: htmlContent]"/>
</browser:isChrome>

<browser:isFirefox>
    <g:render template="/page/regions" model="[htmlContent: htmlContent]"/>
</browser:isFirefox>

<browser:isOpera>
    <g:render template="/page/regions" model="[htmlContent: htmlContent]"/>
</browser:isOpera>

<browser:isMobile>
    <g:javascript>
        document.location = 'page/mobile'
    </g:javascript>
</browser:isMobile>

</body>
</html>