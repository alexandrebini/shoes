@Shoes.module 'BrandsApp', (BrandsApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  class BrandsApp.Router extends Marionette.AppRouter
    addBrandsRoutes: (slugs) ->
      _.each slugs, (slug) =>
        @route "#{ slug }/", => API.show(slug)
        @route "#{ slug }/pg-:page/", (page) => API.show(slug, page)

  API =
    show: (slug, page) ->
      @controller = new BrandsApp.Show.Controller
        slug: slug
        page: page
      App.vent.trigger 'set:current:brand', slug

    disable: ->
      @controller.disable() if @controller

    enable: ->
      @controller.enable() if @controller

  App.vent.on 'visit:shoe', ->
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