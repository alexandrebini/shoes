@Shoes.module 'CategoriesApp', (CategoriesApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  class CategoriesApp.Router extends Marionette.AppRouter
    appRoutes:
      'categories/:slug/' : 'show'
      'categories/:slug/pg-:page/' : 'show'
      ':slug/:brand/' : 'brand'
      ':slug/:brand/pg-:page/' : 'brand'

  API =
    show: (slug, page) ->
      category = App.request('category:entity', slug)
      shoes = App.request('category:shoes:entities', slug, page)

      App.execute 'when:fetched', shoes, =>
        @controller = new CategoriesApp.Show.Controller(shoes)
        App.vent.trigger 'category:visited', category

    brand: (slug, brandSlug, page) ->
      category = App.request('category:entity', slug)
      brand = App.request('brand:entity', brandSlug)
      shoes = App.request('category:brand:shoes:entities', slug, brandSlug, page)

      App.execute 'when:fetched', shoes, =>
        @controller = new CategoriesApp.Brand.Controller(shoes)
        App.vent.trigger 'category:brand:visited', category, brand, shoes

    disable: ->
      @controller.disable() if @controller

    enable: ->
      @controller.enable() if @controller

  App.vent.on 'shoe:visited', ->
    API.disable()

  App.vent.on 'visit:category', (slug) ->
    shortSlug = _.compact(slug.split('/'))
    API.show(_.last(shortSlug))
    API.enable()
    App.vent.trigger 'visit', slug

  App.vent.on 'visit:category:brand', (slug, brand) ->
    API.show(slug, brand)
    API.enable()
    App.vent.trigger 'visit', "#{ slug }/#{ brand }"

  CategoriesApp.on 'start', ->
    new CategoriesApp.Router
      controller: API