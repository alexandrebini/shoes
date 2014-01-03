@Shoes.module 'ShoesApp', (ShoesApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  class ShoesApp.Router extends Marionette.AppRouter
    appRoutes:
      '' : 'list'
      ':brand/:category/:slug/' : 'show'

  API =
    list: ->
      new ShoesApp.List.Controller()

    show: (brand, category, slug) ->
      new ShoesApp.Show.Controller(slug)


  ShoesApp.on 'start', ->
    new ShoesApp.Router
      controller: API