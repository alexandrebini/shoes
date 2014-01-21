@Shoes.module 'NavApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends Marionette.Controller
    initialize: (options) ->
      @nav = options.nav

      @layout = @getLayoutView()

      @listenTo @layout, 'show', =>
        @categoriesRegion(options.categories)
        @brandsRegion(options.brands)

      @enable()

    categoriesRegion: (categories) ->
      categoriesView = @getCategoriesView(categories)
      @listenTo categoriesView, 'itemview:category:clicked', (child) =>
        @nav.toggleCurrentCategory child.model
        @visit()
      @layout.categoriesRegion.show categoriesView

    brandsRegion: (brands) ->
      brandsView = @getBrandsView(brands)
      @listenTo brandsView, 'itemview:brand:clicked', (child) =>
        @nav.toggleCurrentBrand child.model
        @visit()
      @layout.brandsRegion.show brandsView

    visit: ->
      category = @nav.get('currentCategory')
      brand = @nav.get('currentBrand')
      switch
        when category && brand
          App.vent.trigger 'visit:category:brand', category.get('slug'), brand.get('slug')
        when category
          App.vent.trigger 'visit:category', category.get('slug')
        when brand
          App.vent.trigger 'visit:brand', brand.get('slug')
        else
          App.vent.trigger 'visit:home'

    getLayoutView: ->
      new Show.Layout

    getCategoriesView: (categories) ->
      new Show.Categories
        collection: categories

    getBrandsView: (brands) ->
      new Show.Brands
        collection: brands

    disable: ->
      @layout.close()
      App.navRegion.$el.hide()

    enable: ->
      App.navRegion.show @layout
      App.navRegion.$el.show()