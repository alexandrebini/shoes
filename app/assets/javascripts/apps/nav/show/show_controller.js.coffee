@Shoes.module 'NavApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends Marionette.Controller
    initialize: ->
      @categories = App.request('category:entities')
      @brands = App.request('brand:entities')

      @layout = @getLayoutView()
      @listenTo @layout, 'show', =>
        @categoriesRegion()
        @brandsRegion()

      App.navRegion.show @layout

    categoriesRegion: ->
      categoriesView = @getCategoriesView()
      @layout.categoriesRegion.show categoriesView

    brandsRegion: ->
      brandsView = @getBrandsView()
      @layout.brandsRegion.show brandsView

    getLayoutView: ->
      new Show.Layout

    getCategoriesView: ->
      new Show.Categories
        collection: @categories

    getBrandsView: ->
      new Show.Brands
        collection: @brands