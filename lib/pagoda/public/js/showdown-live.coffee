class ShowdownLive
  constructor: (@selector)->
    # Hide the textarea
    width  = $(@selector).width()
    height = $(@selector).height()
    $(@selector).css('display', 'none')

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
    html      = converter.makeHtml($(@selector).val());
    @livenode.html(html)

    @log "Initing #{@selector} as ShowdownLive"

  keyhandle: (e) =>
    shdlv_html = @livenode.html()
    shdlv_html = shdlv_html.replace(/<p>/g,"\n")
    shdlv_html = shdlv_html.replace(/<\/p>/g,"\n")
    shdlv_html = shdlv_html.replace(/<br>/g,"\n")
    $(@selector).val(shdlv_html)

  log: (message)->
    console.log message

window.ShowdownLive = ShowdownLive