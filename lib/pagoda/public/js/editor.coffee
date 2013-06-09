$(document).ready ->

  key.filter = (e)->
    true

  is_iphone =->
    /iPhone/i.test(navigator.userAgent)
 
  is_edit_page = ->
    window.location.pathname.indexOf('edit') != -1

  set_save_button = (status)->
    if(status == 'saving')
      $('#save-button').val('SAVING')
      $('#save-button').addClass('post-saving')
    else if status == 'saved'
      $('#save-button').val('SAVED')
      setTimeout((->
        $('#save-button').val('SAVE')
        $('#save-button').removeClass('post-saving')
      ), 1000)
    else if status == 'error'
      $('#save-button').val('Error')
      $('#save-button').removeClass('post-saving')
      setTimeout((->set_save_button('saved')),2000)

  draft_post = ->
    $('#draft-action').addClass('selected')
    $('#publish-action').removeClass('selected')
    $('.override-select').removeClass('override-select')
    $('[name="yaml_value[published]"]').val("false")
    save_post()
    false

  publish_post = ->
    $('#draft-action').removeClass('selected')
    $('#publish-action').addClass('selected')
    $('.override-select').removeClass('override-select')
    $('[name="yaml_value[published]"]').val("true")
    save_post()
    false


  # Save post
  save_post = ->
    clear_empty_yaml()
    set_save_button('saving')

    post_obj = 
      post : 
        title   : $('#post-title').val()
        content : $('#post-content').val()
        name    : $('#post_name').val()
        yaml    : yaml_hash()

      ajax    : true

    $.post(baseUrl + '/save-post', post_obj, (data)->
      response = $.parseJSON(data)
      if response['status'] == 'OK'
        setTimeout((->set_save_button('saved')),1000)
      else
        set_save_button('error')
    )
    .fail((->set_save_button('error')))

  add_yaml_entry = ->
    html = $('#add-yaml-template').html()
    $(html).insertBefore($('.add-yaml-entry'))
    $('.yaml-table-inner .key input').focus()

    $('.yaml-table-inner input').unbind('keyup', yaml_table_set_data)    
    $('.yaml-table-inner input').bind('keyup', yaml_table_set_data)

  clear_empty_yaml =->
    rows = $('.yaml-table-inner input.yaml-value')

    for row in rows
      if $(row).val() == ''
        $(row).parent().parent().remove()

  yaml_hash =->
    rows = $('.yaml-table-inner input.yaml-value')
    hash = {}
    for row in rows
      name  = $(row).attr('name').replace("yaml_value[", "").replace("]", "")
      value = $(row).val()
      hash[name] = value

    hash


  toggle_yaml_table = ->
    console.log(yaml_hash())
    $('.yaml-table').toggle()

  yaml_table_set_data = ->
    rows = $('.yaml-table-inner input')
    for row in rows
      if $(row).hasClass('yaml-key')
        value = $(row).val()
        value = value.replace(" ","-")
        $(row).val(value)
        name  = "yaml_key[#{value}]"
        $(row).attr('name', name)
      else if $(row).hasClass('yaml-value')
        key   = $(row).parent().parent().find('.yaml-key').val()
        name  = "yaml_value[#{key}]"
        $(row).attr('name', name)

  # Dom invoked events
  handle_events =->
    $('#post-editor #post-title').autosize({append: "\n"})

    $("#fullscreen").click (e)->
      screenfull.request();

    $(".draft-options a").hover (->
      if not $(this).hasClass('selected')
        $(".draft-options a.selected").addClass('override-select')
      ),(->
      if not $(this).hasClass('selected')
        $(".draft-options a.selected").removeClass('override-select')
      )

    screenfull.onchange = ->
      if screenfull.isFullscreen
        $('#fullscreen').hide()
        $('#post-content').focus()

        setTimeout( ->
          rows = Math.ceil($(window).height()/40)
          $('#post-content').attr('rows', rows)
        , 1000)

      else
        $('#fullscreen').show();
        $('#post-content').attr('rows', 18);

    $('.delete-button').click ->
      if not confirm("Confirm delete?")
        return false

    $('#post-content').bind 'scroll', (e)->
      if $(this).scrollTop() > 10
        $(this).addClass('scrolled')
      else
        $(this).removeClass('scrolled')

    if is_edit_page()
      $('#save-button').click( ->
        save_post()
        false
      )

      $('#draft-action').click(draft_post)
      $('#publish-action').click(publish_post)
      $('.add-yaml-entry').click(add_yaml_entry)
      $('.yaml-block .button').click(toggle_yaml_table)
      $('.yaml-table-inner input').bind('keyup', yaml_table_set_data)

  keyboard_events =->
    key('⌘+enter, ctrl+enter', (e)->
      screenfull.toggle()
    )

    key('⌘+s, ctrl+s',(e) ->
      if not is_edit_page()
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


  focus_to_type =->
    if not is_edit_page() and ($('#post-title').val() == '')
      $('#post-title').focus()
    else
      $('#post-content').focus()


  fullscreen_mobile =->
    if(is_iphone())
      setTimeout (->
        # Hide the address bar!
        window.scrollTo 0, 1
      ), 0
      $('.links').remove()

  init =->
    handle_events()
    keyboard_events()
    show_shortcuts() if not is_iphone()
    focus_to_type()
    fullscreen_mobile()
    yaml_table_set_data()

  init()