@Shoes.module 'ShoesApp', (ShoesApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  class ShoesApp.Router extends Marionette.AppRouter
    appRoutes:
      '' : 'list'
      'pg-:page/' : 'list'
      ':category/:brand/:shoe/' : 'show'

  API =
    list: (page) ->
      @closeShoe()
      new ShoesApp.List.Controller(page)

    show: (category, brand, slug) ->
      @showController = new ShoesApp.Show.Controller
        category: category
        brand: brand
        slug: slug

    closeShoe: ->
      @showController.layout.close() if @showController

  App.vent.on 'visit:home', (slug) ->
    API.list()
    App.vent.trigger 'visit', '/'

  ShoesApp.on 'start', ->
    new ShoesApp.Router
      controller: API