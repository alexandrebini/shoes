@Shoes.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Brand extends Backbone.Model
    idAttribute: 'slug'
    url: ->
      Routes.brand_path @get('slug')

  API =
    getBrand: (slug) ->
      brand = new Entities.Brand(slug: slug)
      brand.fetch()
      brand

    getBrandShoes: (slug, page) ->
      shoes = new Entities.ShoesPagination()
      shoes.state.setPage(page)
      shoes.url = (options) =>
        default_options = { slug: slug }
        options = _.extend(default_options, options)
        Routes.brand_shoes_path options
      shoes.fetch()
      shoes

  App.reqres.setHandler 'brand:entity', (slug) ->
    API.getBrand(slug)

  App.reqres.setHandler 'brand:shoes:entities', (slug, page) ->
    API.getBrandShoes(slug, page)