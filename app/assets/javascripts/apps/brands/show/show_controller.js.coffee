@Shoes.module 'BrandsApp.Show', (Show, App, Backbone, Marionette, $, _) ->
  class Show.Controller extends App.Components.ShoesList.Controller
    initialize: (options) ->
      @brand = App.request('brand:entity', options)
      window.a = @brand
      super @brand.get('shoes')