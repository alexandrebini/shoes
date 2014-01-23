@Shoes.module 'CategoriesApp', (CategoriesApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  class CategoriesApp.Router extends Marionette.AppRouter
    appRoutes:
      ':slug/' : 'show'
      ':slug/pg-:page/' : 'show'
      ':slug/:brand/shoes/' : 'brand'
      ':slug/:brand/shoes/pg-:page/' : 'brand'

  API =
    show: (slug, page) ->
      category = App.request('category:entity', slug)
      shoes = App.request('category:shoes:entities', slug, page)
      @controller = new CategoriesApp.Show.Controller(shoes)
      App.vent.trigger 'category:visited', category

    brand: (slug, brandSlug, page) ->
      category = App.request('category:entity', slug)
      brand = App.request('brand:entity', brandSlug)
      shoes = App.request('category:brand:shoes:entities', slug, brandSlug, page)
      @controller = new CategoriesApp.Brand.Controller(shoes)
      App.vent.trigger 'category:brand:visited', category, brand, shoes

    disable: ->
      @controller.disable() if @controller

    enable: ->
      @controller.enable() if @controller

  App.vent.on 'shoe:visited', ->
    API.disable()

  App.vent.on 'visit:category', (slug) ->
    API.show(slug)
    API.enable()
    App.vent.trigger 'visit', slug

  App.vent.on 'visit:category:brand', (slug, brand) ->
    API.brand(slug, brand)
    API.enable()
    App.vent.trigger 'visit', "#{ slug }/#{ brand }/shoes"

  CategoriesApp.on 'start', ->
    new CategoriesApp.Router
      controller: API