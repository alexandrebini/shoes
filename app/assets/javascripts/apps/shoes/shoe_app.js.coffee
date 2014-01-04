@Shoes.module 'ShoesApp', (ShoesApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  class ShoesApp.Router extends Marionette.AppRouter
    appRoutes:
      '' : 'list'
      'pg-:page/' : 'list'

  API =
    list: (page) ->
      new ShoesApp.List.Controller(page)

  ShoesApp.on 'start', ->
    new ShoesApp.Router
      controller: API