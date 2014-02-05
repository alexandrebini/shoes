@Shoes.module 'HeaderApp', (HeaderApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  API =
    show: -> @controller = new App.HeaderApp.Show.Controller()
    hasH1: -> @controller.logoRegion(hasH1: true)
    withoutH1: -> @controller.logoRegion(hasH1: false)
    enable: -> App.headerRegion.$el.show()
    disable: -> App.headerRegion.$el.hide()

  App.vent.on 'home:visited shoe:visited category:visited brand:visited category:brand:visited', ->
    API.enable()

  App.vent.on 'throw:error', ->
    API.disable()

  App.vent.on 'shoe:visited category:visited brand:visited category:brand:visited', ->
    API.withoutH1()

  App.vent.on 'home:visited', ->
    API.hasH1()

  App.vent.on 'home:visited category:visited brand:visited category:brand:visited', ->
    App.request 'header:update:logo:path', { beforePath: false }

  App.vent.on 'shoe:visited navigate', ->
    App.request 'header:update:logo:path', { beforePath: true }

  HeaderApp.on 'start', ->
    API.show()