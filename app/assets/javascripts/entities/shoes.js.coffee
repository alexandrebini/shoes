@Shoes.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Shoe extends Backbone.Model
    urlRoot: -> Routes.shoes_path()
    idAttribute: 'slug'

  class Entities.ShoesCollection extends Backbone.Collection
    model: Entities.Shoe
    url: -> Routes.shoes_path()

  API =
    getShoes: ->
      shoes = new Entities.ShoesCollection
      shoes.fetch()
      shoes

  App.reqres.setHandler 'shoes:entities', ->
    API.getShoes()