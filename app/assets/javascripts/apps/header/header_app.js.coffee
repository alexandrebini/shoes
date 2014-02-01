@Shoes.module 'HeaderApp', (HeaderApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  API =
    show: -> @controller = new App.HeaderApp.Show.Controller()
    hasH1: -> @controller.logoRegion(hasH1: true)
    withoutH1: -> @controller.logoRegion(hasH1: false)
    enable: -> App.headerRegion.$el.show()
    disable: -> App.headerRegion.$el.hide()

  App.vent.on 'shoe:visited category:visited brand:visited category:brand:visited', ->
    API.withoutH1()
    API.enable()

  App.vent.on 'home:visited', ->
    API.hasH1()
    API.enable()

  App.vent.on 'throw:error', ->
    API.disable()

  HeaderApp.on 'start', ->
    API.show()