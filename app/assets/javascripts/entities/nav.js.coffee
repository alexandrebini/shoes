@Shoes.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Nav extends Backbone.Model
    initialize: ->
      @set
        currentCategory: null
        currentBrand: null
      @on 'change:currentCategory', @onCurrentCategoryChange, @
      @on 'change:currentBrand', @onCurrentBrandChange, @

    fetch: ->
      @set
        categories: App.request('category:entities')
        brands: App.request('brand:entities')

    setCurrentCategory: (slug) ->
      @set currentCategory: @get('categories').findWhere(slug: slug)

    toggleCurrentCategory: (currentCategory) ->
      if currentCategory == @get('currentCategory')
        @set currentCategory: null
      else
        @set currentCategory: currentCategory

    setCurrentBrand: (slug) ->
      @set currentBrand: @get('brands').findWhere(slug: slug)

    toggleCurrentBrand: (currentBrand) ->
      if currentBrand == @get('currentBrand')
        @set currentBrand: null
      else
        @set currentBrand: currentBrand

    onCurrentCategoryChange: ->
      @get('categories').each (category) =>
        category.set isCurrent: category == @get('currentCategory')
      @updatePaths()

    onCurrentBrandChange: ->
      @get('brands').each (brand) =>
        brand.set isCurrent: brand == @get('currentBrand')
      @updatePaths()

    updatePaths: ->
      @updateCategoriesPaths()
      @updateBrandsPaths()

    updateCategoriesPaths: ->
      @get('categories').each (category) =>
        if @get('currentBrand')
          category.set path: @pathTo(category, @get('currentBrand'))
        else
          category.set path: null

    updateBrandsPaths: ->
      @get('brands').each (brand) =>
        if @get('currentCategory')
          brand.set path: @pathTo(@get('currentCategory'), brand)
        else
          brand.set path: null

    pathTo: (category, brand) ->
      switch
        when category && brand then "#{ category.get('slug') }/#{ brand.get('slug') }"
        when category then category.get('slug')
        when brand then category.get('slug')
        else null

  API =
    getNavEntities: ->
      brand = new Entities.Nav()
      brand.fetch()
      brand

  App.reqres.setHandler 'nav:entities', ->
    API.getNavEntities()