<g:set var="entityCode"
       value="${record.metaClass.respondsTo(record, 'entityCode') ? record.entityCode() : record.class?.name?.split(/\./).last()}"/>


<div class="recordDetailsBody" style="margin-left: 5px;" id="detailsRegion${entityCode}${record.id}">

<div id="panelComments${entityCode}Record${record.id}">
    <g:render template="/indexCard/add"
              model="[recordId: record.id, recordEntityCode: entityCode, language: (entityCode == 'R' ? record.language : 'ar')]"/>
</div>


<g:set var="entityCode"
       value="${record.metaClass.respondsTo(record, 'entityCode') ? record.entityCode() : record.class?.name?.split(/\./).last()}"/>


</div>