@Shoes.module 'CategoriesApp.Show', (Show, App, Backbone, Marionette, $, _) ->
  class Show.Controller extends App.Components.ShoesList.Controller
    initialize: (options) ->
      @category = App.request('category:entity', options.slug)
      @shoes = App.request('category:shoes:entities', options.slug, options.page)
      super @shoes