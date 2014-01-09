@Shoes.module 'CategoriesApp', (CategoriesApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  class CategoriesApp.Router extends Marionette.AppRouter
    appRoutes:
      ':slug/' : 'show'
      ':slug/pg-:page/' : 'show'
      ':slug/:brand/' : 'brand'
      ':slug/:brand/pg-:page/' : 'brand'

  API =
    show: (slug, page) ->
      new CategoriesApp.Show.Controller
        slug: slug
        page: page
      App.vent.trigger 'set:current:category', slug

    brand: (slug, brand, page) ->
      new CategoriesApp.Brand.Controller
        slug: slug
        brand: brand
        page: page
      App.vent.trigger 'set:current:category', slug
      App.vent.trigger 'set:current:brand', brand

  App.vent.on 'visit:category', (slug) ->
    API.show(slug)
    App.vent.trigger 'visit', slug

  App.vent.on 'visit:category:brand', (slug, brand) ->
    API.show(slug, brand)
    App.vent.trigger 'visit', "#{ slug }/#{ brand }"

  CategoriesApp.on 'start', ->
    new CategoriesApp.Router
      controller: API