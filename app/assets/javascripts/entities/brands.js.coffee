@Shoes.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  # class Entities.ShoesPagination extends App.Components.Pagination.Entities.Pagination
  #   model: Entities.ShoesCollection
  #   url: Routes.shoes_path

  class Entities.Brand extends Backbone.Model
    idAttribute: 'slug'
    url: ->
      Routes.brand_path(@get('slug'))

    initialize: ->
      console.log 'initialize'
      shoes = new Entities.ShoesPagination()
      shoes.url = => @url()
      @set shoes: shoes

    parse: (response) ->
      window.b = response
      @get('shoes').set response.shoes, { parse: true }

      # @set shoes: new Entities.ShoesPagination(response.shoes, { parse:true })
      window.foo = @
      delete response.shoes
      response

  API =
    getBrand: (slug, page) ->
      console.log '------------getBrand', slug, page
      brand = new Entities.Brand(slug: slug)
      brand.get('shoes').state.setPage(page)
      brand.fetch()
      brand

  App.reqres.setHandler 'brand:entity', (options) ->
    API.getBrand(options.slug, options.page)