@Shoes.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Category extends Backbone.Model
    idAttribute: 'slug'
    url: ->
      Routes.category_path @get('slug')

  class Entities.CategoryCollection extends Backbone.Collection
    @getInstance: -> @_instance ?= new @(arguments...)
    model: Entities.Category
    url: Routes.categories_path

  API =
    getCategory: (slug) ->
      brand = new Entities.Category(slug: slug)
      brand.fetch()
      brand

    getCategories: ->
      categories = Entities.CategoryCollection.getInstance()
      categories.fetch()
      categories

    getCategoryShoes: (slug, page) ->
      shoes = new Entities.ShoesPagination()
      shoes.state.setPage(page)
      shoes.url = (options) =>
        default_options = { slug: slug }
        options = _.extend(default_options, options)
        Routes.category_shoes_path options
      shoes.fetch()
      shoes

    getCategoryBrandShoes: (slug, brand, page) ->
      shoes = new Entities.ShoesPagination()
      shoes.state.setPage(page)
      shoes.url = (options) =>
        default_options = { slug: slug, brand: brand }
        options = _.extend(default_options, options)
        Routes.category_brand_shoes_path options
      shoes.fetch()
      shoes

  App.reqres.setHandler 'category:entity', (slug) ->
    API.getCategory(slug)

  App.reqres.setHandler 'category:entities', ->
    API.getCategories()

  App.reqres.setHandler 'category:shoes:entities', (slug, page) ->
    API.getCategoryShoes(slug, page)

  App.reqres.setHandler 'category:brand:shoes:entities', (slug, brand, page) ->
    API.getCategoryBrandShoes(slug, brand, page)