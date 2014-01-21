@Shoes.module 'Components.ShoeMeta.Entities', (Entities, App, Backbone, Marionette, $, _) ->
  class Entities.ShoeMeta extends Backbone.Model
    initialize: (game) ->
      console.log game.attributes

      {
        title: "#{ game.get('category').name } #{ game.get('name') } #{ game.get('brand').name } - Busca Sapato",
        metaDescription: game.description
      }