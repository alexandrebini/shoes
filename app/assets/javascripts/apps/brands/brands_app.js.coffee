@Shoes.module 'BrandsApp', (BrandsApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  class BrandsApp.Router extends Marionette.AppRouter
    addBrandsRoutes: (slugs) ->
      _.each slugs, (slug) =>
        @route "#{ slug }/", => API.show(slug)
        @route "#{ slug }/pg-:page/", (page) => API.show(slug, page)

  API =
    show: (slug, page) ->
      brand = App.request('brand:entity', slug)
      shoes = App.request('brand:shoes:entities', slug, page)
      @controller = new BrandsApp.Show.Controller(shoes)
      App.vent.trigger 'brand:visited', brand

    disable: ->
      @controller.disable() if @controller

    enable: ->
      @controller.enable() if @controller

  App.vent.on 'shoe:visited', ->
    API.disable()

  App.vent.on 'visit:brand', (slug) ->
    API.show(slug)
    API.enable()
    App.vent.trigger 'visit', slug

  BrandsApp.on 'start', (slugs) ->
    router = new BrandsApp.Router
      controller: API
    router.addBrandsRoutes(slugs)
    router