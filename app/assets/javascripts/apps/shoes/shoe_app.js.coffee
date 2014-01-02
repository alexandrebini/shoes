@Shoes.module 'ShoesApp', (ShoesApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  class ShoesApp.Router extends Marionette.AppRouter
    appRoutes:
      '' : 'list'

  API =
    list: ->
      new ShoesApp.List.Controller()

  ShoesApp.on 'start', ->
    new ShoesApp.Router
      controller: API