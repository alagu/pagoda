class ShowdownLive
  constructor: (@selector)->
    # Hide the textarea
    $(@selector).css('display', 'none')

    # Insert a live node
    livenode  = $('<div contenteditable="true" class="showdown-live"></div>')
    livenode.insertAfter(@selector)

    # Put HTML inside livenode
    converter = new Showdown.converter();
    html      = converter.makeHtml($(@selector).val());
    livenode.html(html)

    @log "Initing #{@selector} as ShowdownLive"

  log: (message)->
    console.log message

window.ShowdownLive = ShowdownLive