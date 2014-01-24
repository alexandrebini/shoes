@Shoes.module 'HeaderApp', (HeaderApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false
  class HeaderApp.Getter
    @getInstance: ->
      @_instance ?= new @(arguments...)

    constructor: -> @controller = new App.HeaderApp.Show.Controller()
    hasH1: -> @controller.logoRegion(true)
    withoutH1: -> @controller.logoRegion()

  API =
    show: -> HeaderApp.Getter.getInstance()
    hasH1: -> HeaderApp.Getter.getInstance().hasH1()
    withoutH1: -> HeaderApp.Getter.getInstance().withoutH1()

  App.vent.on 'shoe:visited category:visited brand:visited category:brand:visited', ->
    API.withoutH1()

  App.vent.on 'home:visited', ->
    API.hasH1()

  HeaderApp.on 'start', ->
    API.show()
