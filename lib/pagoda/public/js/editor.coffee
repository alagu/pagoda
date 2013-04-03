$(document).ready ->

  $('#post-editor #post_title').autosize({append: "\n"})

  $("#options").click (e)->
    $('#post-editor').fullScreen({background : '#fff'});