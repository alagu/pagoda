$(document).ready ->

  $('#post-editor #post_title').autosize({append: "\n"})

  $("#fullscreen").click (e)->
    screenfull.request();

  screenfull.onchange = ->
    if screenfull.isFullscreen
      $('#fullscreen').hide();
    else
      $('#fullscreen').show();