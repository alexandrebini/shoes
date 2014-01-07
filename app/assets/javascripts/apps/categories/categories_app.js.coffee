@Shoes.module 'CategoriesApp', (CategoriesApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  class CategoriesApp.Router extends Marionette.AppRouter
    appRoutes:
      ':category/' : 'list'
      ':category/pg-:page/' : 'list'
      ':category/:brand/' : 'list'
      ':category/:brand/pg-:page/' : 'list'

  # API =
  #   list: (page) ->
  #     new ShoesApp.List.Controller(page)

  #   show: (brand, category, slug) ->
  #     new ShoesApp.Show.Controller(slug)

  # ShoesApp.on 'start', ->
  #   new ShoesApp.Router
  #     controller: API