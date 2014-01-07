@Shoes.module 'ShoesApp', (ShoesApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  class ShoesApp.Router extends Marionette.AppRouter
    appRoutes:
      '' : 'list'
      'pg-:page/' : 'list'
      ':category/:brand/:shoe/' : 'show'

  API =
    list: (page) ->
      new ShoesApp.List.Controller(page)

    show: (brand, category, slug) ->
      new ShoesApp.Show.Controller(slug)

  ShoesApp.on 'start', ->
    new ShoesApp.Router
      controller: API