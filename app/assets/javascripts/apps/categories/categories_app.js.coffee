@Shoes.module 'CategoriesApp', (CategoriesApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  class CategoriesApp.Router extends Marionette.AppRouter
    addBrandsRoutes: (slugs) ->
      _.each slugs, (slug) =>
        @route "#{ slug }/", => API.show(slug)
        @route "#{ slug }/pg-:page/", (page) => API.show(slug, page)

    appRoutes:
      ':slug/:brand/' : 'brand'
      ':slug/:brand/pg-:page/' : 'brand'

  API =
    show: (slug, page) ->
      category = App.request('category:entity', slug)
      shoes = App.request('category:shoes:entities', slug, page)
      App.vent.trigger 'category:visited', category
      @controller = new CategoriesApp.Show.Controller(shoes)

    brand: (slug, brandSlug, page) ->
      category = App.request('category:entity', slug)
      brand = App.request('brand:entity', brandSlug)
      shoes = App.request('category:brand:shoes:entities', slug, brandSlug, page)
      App.vent.trigger 'category:brand:visited', category, brand, shoes
      @controller = new CategoriesApp.Brand.Controller(shoes)

    disable: ->
      @controller.disable() if @controller

    enable: ->
      @controller.enable() if @controller

  App.vent.on 'shoe:visited', ->
    API.disable()

  App.vent.on 'visit:category', (slug) ->
    API.show(slug)
    API.enable()
    App.vent.trigger 'visit', { route: slug, visit: false }

  App.vent.on 'visit:category:brand', (slug, brand) ->
    API.brand(slug, brand)
    API.enable()
    App.vent.trigger 'visit', { route: "#{ slug }/#{ brand }", visit: false }

  CategoriesApp.on 'start', (slugs) ->
    router = new CategoriesApp.Router
      controller: API

    router.addBrandsRoutes(slugs)
    router