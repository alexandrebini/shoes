@Shoes.module 'HeaderApp', (HeaderApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false
  class HeaderApp.Getter
    @getInstance: ->
      @_instance ?= new @(arguments...)

    constructor: ->
      @controller = new App.HeaderApp.Show.Controller()

    h1Add: ->
      @controller.setH1View()

    h1Remove: ->
      @controller.removeH1View()

  API =
    show: -> HeaderApp.Getter.getInstance()
    h1Add: -> HeaderApp.Getter.getInstance().h1Add()
    h1Remove: -> HeaderApp.Getter.getInstance().h1Remove()

  App.vent.on 'shoe:visited category:visited brand:visited category:brand:visited', ->
    API.h1Remove()

  App.vent.on 'home:visited', ->
    API.h1Add()

  HeaderApp.on 'start', ->
    API.show()
