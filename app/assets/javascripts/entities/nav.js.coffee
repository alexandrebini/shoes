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
      category = null
      category = @get('categories').findWhere(slug: slug) if slug?

      currentBrand = @get('currentBrand')
      if category && currentBrand && !_.contains category.get('brands'), currentBrand.get('slug')
        currentBrand = null

      @set
        currentBrand: currentBrand
        currentCategory: category

    toggleCurrentCategory: (category) ->
      if category == @get('currentCategory')
        @setCurrentCategory null
      else
        @setCurrentCategory category.get('slug')

    setCurrentBrand: (slug) ->
      brand = null
      brand = @get('brands').findWhere(slug: slug) if slug?

      currentCategory = @get('currentCategory')
      if brand && currentCategory && !_.contains brand.get('categories'), currentCategory.get('slug')
        currentCategory = null

      @set
        currentCategory: currentCategory
        currentBrand: brand

    toggleCurrentBrand: (brand) ->
      if brand == @get('currentBrand')
        @setCurrentBrand null
      else
        @setCurrentBrand brand.get('slug')

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
      currentBrand = @get('currentBrand')
      @get('categories').each (category) =>
        if currentBrand && _.contains category.get('brands'), currentBrand.get('slug')
          category.set path: "#{ category.get('slug') }/#{ currentBrand.get('slug') }"
        else
          category.set path: null

    updateBrandsPaths: ->
      currentCategory = @get('currentCategory')
      @get('brands').each (brand) =>
        if currentCategory && _.contains brand.get('categories'), currentCategory.get('slug')
          brand.set path: "#{ currentCategory.get('slug') }/#{ brand.get('slug') }"
        else
          brand.set path: null

  API =
    getNavEntities: ->
      brand = new Entities.Nav()
      brand.fetch()
      brand

  App.reqres.setHandler 'nav:entities', ->
    API.getNavEntities()