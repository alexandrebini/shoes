@Shoes.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Nav extends Backbone.Model
    initialize: ->
      @set
        currentCategory: null
        currentBrand: null
        categories: new Backbone.Collection()
        brands: new Backbone.Collection()

      @on 'change:currentCategory', @onCurrentCategoryChange, @
      @on 'change:currentBrand', @onCurrentBrandChange, @

    fetch: ->
      @allCategories = App.request('category:entities')
      @allBrands = App.request('brand:entities')

      App.execute 'when:fetched', @allBrands, =>
        @update()

      App.execute 'when:fetched', @allCategories, =>
        @update()

    setCurrentCategory: (slug) ->
      App.execute 'when:fetched', @allCategories, =>
        category = @allCategories.findWhere({ slug: slug })
        if @get('currentCategory') != category
          @set currentCategory: category

    toggleCurrentCategory: (currentCategory) ->
      if currentCategory == @get('currentCategory')
        @set currentCategory: null
      else
        @set currentCategory: currentCategory

    setCurrentBrand: (slug) ->
      App.execute 'when:fetched', @allBrands, =>
        brand = @allBrands.findWhere({ slug: slug })
        if @get('currentBrand') != brand
          @set currentBrand: brand

    toggleCurrentBrand: (currentBrand) ->
      if currentBrand == @get('currentBrand')
        @set currentBrand: null
      else
        @set currentBrand: currentBrand

    setCategoryH1: (category) ->
      isH1 = if @get('currentBrand')
        false
      else
        true

      category.set isH1: isH1

    onAllCategoryH1Change: ->
      @allCategories.each (category) =>
        @setCategoryH1(category)

    onCurrentCategoryChange: ->
      @allCategories.each (category) =>
        category.set isCurrent: category == @get('currentCategory')
        @setCategoryH1(category)

      @update()

    onCurrentBrandChange: ->
      @allBrands.each (brand) =>
        brand.set isCurrent: brand == @get('currentBrand')
        @onAllCategoryH1Change()
      @update()

    update: ->
      @updateCategories()
      @updateBrands()
      @updateCategoriesPaths()
      @updateBrandsPaths()

    updateCategories: ->
      if @get('currentBrand')
        @get('categories').reset @allCategories.filter (category) =>
          _.contains @get('currentBrand').get('categories'), category.get('slug')
      else
        @get('categories').reset @allCategories.models

    updateCategoriesPaths: ->
      @get('categories').each (category) =>
        if @get('currentBrand')
          category.set path: @pathTo(category, @get('currentBrand'))
        else
          category.set path: null

    updateBrands: ->
      if @get('currentCategory')
        @get('brands').reset @allBrands.filter (brand) =>
          _.contains @get('currentCategory').get('brands'), brand.get('slug')
      else
        @get('brands').reset @allBrands.models

    updateBrandsPaths: ->
      @get('brands').each (brand) =>
        if @get('currentCategory')
          brand.set path: @pathTo(@get('currentCategory'), brand)
        else
          brand.set path: null

    pathTo: (category, brand) ->
      switch
        when category && brand then "#{ category.get('slug') }/#{ brand.get('slug') }/"
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