$(document).ready ->

  # Keymaster doesn't allow INPUT, TEXTAREA to have shortcuts.
  # Override it.
  key.filter = (e)->
    true

  set_save_button = (status)->
    if(status == 'saving')
      $('#save-button').val('Saving')
      $('#save-button').addClass('saving')
    else if status == 'saved'
      $('#save-button').val('Saved')
      $('#save-button').removeClass('saving')
      setTimeout((->$('#save-button').val('Save')), 1000)
    else if status == 'error'
      $('#save-button').val('Error')
      $('#save-button').removeClass('saving')
      setTimeout((->set_save_button('saved')),2000)

  # Save post
  save_post = ->
    set_save_button('saving')
    draft =

    post_obj = 
      post : 
        title   : $('#post_title').val()
        content : $('#post_content').val()
        name    : $('#post_name').val()
        draft   : $('#post_draft').val()

      ajax    : true

    try 
      $.post('/save-post', post_obj, (data)->
        response = $.parseJSON(data)
        if response['status'] == 'OK'
          setTimeout((->set_save_button('saved')),1000)
        else
          set_save_button('error')
      )
    catch error
      set_save_button('error')


    console.log(post_obj)

  # Dom invoked events
  handle_events =->
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

  keyboard_events =->
    key('⌘+enter, ctrl+enter', (e)->
      screenfull.toggle()
    )

    key('⌘+s, ctrl+s',(e) ->
      if window.location.pathname.indexOf('edit') == -1
        $('.edit_post').submit()
      else
        save_post()
      false
    )


  show_shortcuts =->
    is_mac = navigator.platform.toUpperCase().indexOf('MAC')>=0;
    special_key = if is_mac then '⌘' else 'ctrl'


    save_shortcut  = special_key + '+S'
    fulls_shortcut = special_key + '+Enter'
  
    $('#save-button').attr('title', save_shortcut)
    $('#fullscreen').attr('title', fulls_shortcut)
    $("#save-button").tipTip({delay: 200})
    $("#fullscreen").tipTip({delay: 200, defaultPosition: 'right'})


  init =->
    handle_events()
    keyboard_events()
    show_shortcuts()


  init()