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
      console.log 'shoeeeww', slug, page
      new CategoriesApp.Show.Controller
        slug: slug
        page: page

    brand: (slug, brand, page) ->
      new CategoriesApp.Brand.Controller
        slug: slug
        brand: brand
        page: page

  CategoriesApp.on 'start', ->
    new CategoriesApp.Router
      controller: API