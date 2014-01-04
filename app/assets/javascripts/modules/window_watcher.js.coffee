@Shoes.module 'WindowWatcher', (WindowWatcher, App, Backbone, Marionette, $, _) ->

  class WindowWatcher.Watcher
    window: $(window)
    document: $(document)
    gap: 100
    scrollTop: 0
    lastScrollTop: 0

    constructor: ->
      @window.on 'scroll', => @checkScroll()

    checkScroll: ->
      @scrollTop = @window.scrollTop()
      switch
        when @scrollTop > @lastScrollTop
          App.vent.trigger 'scroll:bottom' if @nearBottom()
        when @scrollTop < @lastScrollTop
          App.vent.trigger 'scroll:top' if @nearTop()
      @lastScrollTop = @scrollTop

    nearBottom: ->
      @scrollTop > @document.height() - @window.height() - @gap

    nearTop: ->
      @scrollTop < @gap

  WindowWatcher.on 'start', ->
    new WindowWatcher.Watcher()