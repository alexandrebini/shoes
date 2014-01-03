@Shoes.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.GameCollection extends Backbone.Collection
    url: (options) -> Routes.games_path(options)
    model: Entities.Game

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

    getShoe: (slug) ->
      shoe = new Entities.Shoe
      shoe.fetch
        url: Routes.shoe_path(slug)
      shoe

  App.reqres.setHandler 'shoe:entity', (slug) ->
    API.getShoe slug

  App.reqres.setHandler 'shoes:entities', ->
    API.getShoes()
