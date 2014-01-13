@Shoes.module 'NavApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends Marionette.Controller
    initialize: ->
      @nav = App.request('nav:entities')
      @categories = @nav.get('categories')
      @brands = @nav.get('brands')

      @layout = @getLayoutView()


      @listenTo @layout, 'show', =>
        @navRegion()
        @categoriesRegion()
        @brandsRegion()

      App.navRegion.show @layout

      App.vent.on 'set:current:brand', (slug) =>
        App.execute 'when:fetched', @brands, =>
          @nav.setCurrentBrand(slug)

      App.vent.on 'set:current:category', (slug) =>
        App.execute 'when:fetched', @categories, =>
          @nav.setCurrentCategory(slug)

    navRegion: ->
      App.navRegion.$el.show()

    categoriesRegion: ->
      categoriesView = @getCategoriesView()
      @listenTo categoriesView, 'itemview:category:clicked', (child) =>
        @nav.toggleCurrentCategory child.model
        @visit()
      @layout.categoriesRegion.show categoriesView

    brandsRegion: ->
      brandsView = @getBrandsView()
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

    getCategoriesView: ->
      new Show.Categories
        collection: @categories

    getBrandsView: ->
      new Show.Brands
        collection: @brands