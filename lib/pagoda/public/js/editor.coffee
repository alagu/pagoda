$(document).ready ->

  $('#post-editor #post_title').autosize({append: "\n"})

  $("#fullscreen").click (e)->
    screenfull.request();

  screenfull.onchange = ->
    if screenfull.isFullscreen
      $('#fullscreen').hide();
    else
      $('#fullscreen').show();

  $('.delete-button').click ->
    if not confirm("Confirm delete?")
      return false