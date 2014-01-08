@Shoes.module 'CategoriesApp.Brand', (Brand, App, Backbone, Marionette, $, _) ->
  class Brand.Controller extends App.Components.ShoesList.Controller
    initialize: (options) ->
      @category = App.request('category:entity', options.slug)
      @brand = App.request('brand:entity', options.brand)
      @shoes = App.request('category:brand:shoes:entities', options.slug, options.brand, options.page)
      super @shoes