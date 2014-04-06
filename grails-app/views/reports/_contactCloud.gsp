<%@ page import="app.Contact; app.Tag" %>
%{--<div style="margin-bottom: 50px">--}%
    %{--<a href="#" id="tags" name="tags[]" style="width: 200px;"></a>--}%
%{--</div>--}%
<script>
  /*
    $.fn.editable.defaults.mode = 'inline';
    $.fn.editable.defaults.showbuttons = false;
    $('#tags').editable({
        type: 'select2',
        url: '/pkm/operation/quickSave2',
                        pk: 123,
        onblur: 'ignore',
        emptytext: 'Tag...',
        select2: {
            tags: true,
            tokenSeparators: [",", " "],
//            tags: [],
//            separator: ", ",
            createSearchChoice: function (term) {
                return {id: term, text: term};
            },
            placeholder: 'Tag...',
            allowClear: false,
//            multiple: true,
            closeOnSelect: false,
            width: '200px',
            minimumInputLength: 2,
            success: function (response, newValue) {
                if (!response.success) return response.msg;
            },
//            id: function (e) {
//                return e.value;
//            },
            ajax: {
                url: '/pkm/operation/autoCompleteTagsJSON',
                dataType: 'json',
                quietMillis: 0,
                data: function (term, page) {
                    return { query: term };
                },
                results: function (data, page) {
                    return { results: data };
                }
            },
            formatResult: function (employee) {
                return employee.text;
            },
            formatSelection: function (employee) {
                return employee.text;
            }
        }
        /* suucess not needed
         ,
         success: function(response) {
         $('#RequestUser').text(response.newVal);
         }

    });
    */
</script>
<div style="-moz-column-count: 1">
    %{--<ul>--}%
<g:each in="${Contact.list([sort: 'summary', order: 'asc'])}" var="t">
    <span style="list-style-type: none; border-right: 0.5px solid #dddddd; margin: 4px; font-size: ${14 + (t.occurrence ? Math.ceil(Math.log(t.occurrence)) : 0)}px; line-height: 25px;">
        <g:remoteLink controller="generics" action="contactReport" id="${t.id}"
                      update="centralArea">
        ${t.summary} <span style="font-size: 11px;"><i>${t.occurrence}</i></span>
    </g:remoteLink>
    </span>
</g:each>
    %{--</ul>--}%
</div>

    %{--new one (accordion)--}%
%{--<div style="-moz-column-count: 4">--}%
    %{--<ul>--}%
        %{--<g:each in="${Tag.list([sort: 'name', order: 'asc'])}" var="t">--}%
            %{--<li style="list-style-type: circle; font-size: ${13 + (t.occurrence ? Math.ceil(Math.log(t.occurrence)) : 0)}px; line-height: 18px;">--}%
                %{--<g:remoteLink controller="generics" action="tagReport" id="${t.id}"--}%
                              %{--update="centralArea">--}%
                    %{--${t.name} <sup><i>${t.occurrence}</i></sup>--}%
                %{--</g:remoteLink>--}%
            %{--</li>--}%
        %{--</g:each>--}%
    %{--</ul>--}%
%{--</div>--}%
