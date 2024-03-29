@Shoes.module 'ScrollWatcher', (ScrollWatcher, App, Backbone, Marionette, $, _) ->

  class ScrollWatcher.Watcher
    window: $(window)
    document: $(document)
    scrollTop: 0
    lastScrollTop: 0
    topGap: 100
    bottomGap: $(window).height()

    constructor: ->
      @window.on 'scroll mousewheel', => @checkScroll()

    checkScroll: ->
      @scrollTop = @window.scrollTop()

      switch
        when @scrollTop > @lastScrollTop
          App.vent.trigger 'scroll:bottom' if @nearBottom()
        when @scrollTop < @lastScrollTop
          App.vent.trigger 'scroll:top' if @nearTop()

      App.vent.trigger 'scroll', @scrollTop
      @lastScrollTop = @scrollTop

    nearBottom: ->
      @scrollTop > @document.height() - @window.height() - @bottomGap

    nearTop: ->
      @scrollTop < @topGap

  ScrollWatcher.on 'start', ->
    new ScrollWatcher.Watcher()