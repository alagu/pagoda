# How to Build
# The text editor is split into 3 parts:
# Preview + Edit + Preview
# For each preview point find a markdown point equivalent
# At the markdown point - show the markdown text
# At all other points, show the preview text.
# 
# Apply this whenever the cursor position changes.
# Add onclick listener. 
class ShowdownLive
  constructor: (@selector)->
    @selector = $(@selector)
    # Hide the textarea
    width  = @selector.width()
    height = @selector.height()
    @selector.css('display', 'none')

    # Insert a live node
    @livenode  = $('<div contenteditable="true" class="showdown-live"></div>')
    @livenode.insertAfter(@selector)

    @livenode.css('width', width)
    @livenode.css('height', height)

    selector = @selector
    livenode = @livenode
    @livenode.bind('keyup', @keyhandle)


    # Put HTML inside livenode
    converter = new Showdown.converter();
    html      = converter.makeHtml(@selector.val());
    @livenode.html(html)

    @log "Initing ##{@selector.attr('id')} as ShowdownLive"

  keyhandle: (e) =>
    shdlv_html = @livenode.html()
    shdlv_html = shdlv_html.replace(/<p>/g,"\n")
    shdlv_html = shdlv_html.replace(/<\/p>/g,"\n")
    shdlv_html = shdlv_html.replace(/<br>/g,"\n")

    lines      = @selector.val().split("\n")
    @log lines


  log: (message)->
    console.log message

window.ShowdownLive = ShowdownLive