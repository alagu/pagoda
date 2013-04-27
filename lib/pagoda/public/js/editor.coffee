$(document).ready ->

  key.filter = (e)->
    true

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

  key('⌘+enter, ctrl+enter', (e)->
    screenfull.toggle()
  )

  key('⌘+s, ctrl+s',(e) ->
    if window.location.pathname.indexOf('edit') == -1
      $('.edit_post').submit()
    else
      console.log "Ajax save should happen here"
      
    false
  )