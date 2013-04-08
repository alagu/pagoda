$(document).ready ->

  $('#post-editor #post_title').autosize({append: "\n"})

  $("#fullscreen").click (e)->
    screenfull.request();

  screenfull.onchange = ->
    if screenfull.isFullscreen
      $('#fullscreen').hide();

      setTimeout( ->
        console.log $(window).height()
        rows = Math.ceil($(window).height()/40)
        $('#post_content').attr('rows', rows);
      , 1000)

    else
      $('#fullscreen').show();
      $('#post_content').attr('rows', 18);

  $('.delete-button').click ->
    if not confirm("Confirm delete?")
      return false