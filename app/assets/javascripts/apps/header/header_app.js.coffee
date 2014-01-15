@Shoes.module 'HeaderApp', (HeaderApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  API =
    show: ->
      new HeaderApp.Show.Controller()

  App.vent.on 'visit:home', ->
    App.vent.trigger 'visit', '/'

  HeaderApp.on 'start', ->
    API.show()
