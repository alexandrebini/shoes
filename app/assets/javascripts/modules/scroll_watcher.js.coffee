@Shoes.module 'ScrollWatcher', (ScrollWatcher, App, Backbone, Marionette, $, _) ->

  class ScrollWatcher.Watcher
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
        when @scrollTop > @lastScrollTop && @nearBottom()
          App.vent.trigger 'scroll:bottom'
        when @scrollTop < @lastScrollTop && @nearTop()
          App.vent.trigger 'scroll:top'
        else
          App.vent.trigger 'scroll', @scrollTop
      @lastScrollTop = @scrollTop

    nearBottom: ->
      @scrollTop > @document.height() - @window.height() - @gap

    nearTop: ->
      @scrollTop < @gap

  ScrollWatcher.on 'start', ->
    new ScrollWatcher.Watcher()