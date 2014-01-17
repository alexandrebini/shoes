@Shoes.module 'NavApp', (NavApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  API =
    start: ->
      @controller = new NavApp.Show.Controller()

    disable: ->
      @controller.disable()

    enable: ->
      @controller.enable()

  App.vent.on 'visit:shoe', ->
    API.disable()

  App.vent.on 'visit:home visit:brand visit:category visit:category:brand', ->
    API.enable()

  NavApp.on 'start', ->
    API.start()