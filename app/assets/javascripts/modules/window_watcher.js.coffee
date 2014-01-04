@Shoes.module 'WindowWatcher', (WindowWatcher, App, Backbone, Marionette, $, _) ->

  class WindowWatcher.Watcher
    window: $(window)
    document: $(document)
    gap: 100

    constructor: ->
      @window.on 'scroll', => @checkScroll()

    checkScroll: ->
      if @nearBottom()
        App.vent.trigger 'scroll:bottom'

    nearBottom: ->
      @window.scrollTop() > @document.height() - @window.height() - @gap

  WindowWatcher.on 'start', ->
    new WindowWatcher.Watcher()