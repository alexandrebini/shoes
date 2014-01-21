@Shoes.module 'NavApp', (NavApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  API =
    start: ->
      @controller = new NavApp.Show.Controller()

    disable: ->
      @controller.disable()

    enable: ->
      @controller.enable()

  App.vent.on 'shoe:visited', ->
    API.disable()

  App.vent.on 'home:visited brand:visited category:visited category:brand:visited', ->
    API.enable()

  NavApp.on 'start', ->
    API.start()