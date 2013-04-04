$(document).ready ->

  $('#post-editor #post_title').autosize({append: "\n"})

  $("#fullscreen").click (e)->
    $('#split').fullScreen({background : '#fff'});