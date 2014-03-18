<div class="nonPrintable">
    <g:formRemote name="batchShort" url="[controller: 'operation', action: 'addInBatch']" update="addArea"
                  method="post" onComplete="jQuery('#inputTest').val('')">

    %{--title="<br/>jrn/pln type sd time ; ...     <br/>jrn/pln type sd st et ; ...    <br/>jrn/pln type sd ed ; ...    <br/>jrn/pln type date level(=M/d/w/y/e,l) ; ...<br/>task dept title = deliv.    <br/>wrt id ; updates...    <br/>goal type dept ; title...    <br/>task/topic/todo dept title..."--}%
    %{--display: none;--}%
        <g:hiddenField name="sth" value="${new java.util.Date()}"/>
        <g:textArea name="input" id="inputTest" class="ui-corner-all" value="icd note 1010 book b1234 \\ the body"
                    style="width:700px; min-width:700px !important; min-height: 27px; height: 100px; line-height: 15px; background: #eeeeee; margin: 8px;"
                    cols="120" rows="5"/>
    %{--<a onclick="jQuery('#addArea').html('')" style="">&times;</a>--}%
        <g:submitButton name="batch" value="*" accessKey="i" style=" margin-left: 10px; "
                        class="fg-button  ui-widget ui-state-default ui-corner-all"/>

    </g:formRemote>

    %{--<br/> <g:formRemote name="batchShort" url="[controller: 'operation', action: 'addInBatch']" update="addArea"--}%
    %{--method="post">--}%

    %{--title="<br/>jrn/pln type sd time ; ...     <br/>jrn/pln type sd st et ; ...    <br/>jrn/pln type sd ed ; ...    <br/>jrn/pln type date level(=M/d/w/y/e,l) ; ...<br/>task dept title = deliv.    <br/>wrt id ; updates...    <br/>goal type dept ; title...    <br/>task/topic/todo dept title..."--}%
    %{--<g:submitButton name="batch" value="+" accessKey="a" style="visibility: hidden;"--}%
    %{--class="fg-button  ui-widget ui-state-default ui-corner-all"/>--}%

    %{--<g:textField name="input" id="inputTestSingle" class="ui-corner-all"--}%

    %{--style="width:550px; min-width:550px; min-height: 27px; height: 27px; word-wrap: normal;"--}%
    %{--title="You can lookup by: c, w, g, t, jt, pt, gt"--}%
    %{--/>--}%

    %{--</g:formRemote>--}%
</div>

%{--<input id="inputTest" class="ui-corner-all" value="lookup by: c, w, g, t, jt, pt, gt"--}%
%{--style="width:300px;"/>--}%




%{--<a onclick="jQuery('#searchArea').html('')" style="float: right;">&times; s</a> &nbsp;&nbsp;--}%
%{--<a onclick="jQuery('#addArea').html('')" style="float: right;">&times; a</a>--}%



<div id="addArea" class="nonPrintable" style="border-bottom: solid 1px #9f9d94;">

</div>