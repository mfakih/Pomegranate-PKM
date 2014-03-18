%{--<script type="text/javascript">--}%
    %{--jQuery.achtung({message: '${message}', timeout: 5});--}%
%{--</script>--}%

<script type="text/javascript">
  var notice = '<div class="notice">'
+ '<div class="notice-body">'
//+ '<img src="../static/images/icons/info.png"/>'
//+ '<h3></h3>'
+ '<p>${message}</p>'
+ '</div>'
+ '<div class="notice-bottom">'
+ '</div>'
+ '</div>';

  $(notice).purr(
          {
//              fadeInSpeed: 200,
//              fadeOutSpeed: 2000,
//              removeTimer: 5000
          }
  );
</script>