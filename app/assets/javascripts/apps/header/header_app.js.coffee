@Shoes.module 'HeaderApp', (HeaderApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  API =
    show: -> @controller = new App.HeaderApp.Show.Controller()
    hasH1: -> @controller.logoRegion(hasH1: true)
    withoutH1: -> @controller.logoRegion(hasH1: false)

  App.vent.on 'shoe:visited category:visited brand:visited category:brand:visited', ->
    API.withoutH1()

  App.vent.on 'home:visited', ->
    API.hasH1()

  HeaderApp.on 'start', ->
    API.show()
