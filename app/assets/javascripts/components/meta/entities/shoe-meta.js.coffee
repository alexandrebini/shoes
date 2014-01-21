@Shoes.module 'Components.ShoeMeta.Entities', (Entities, App, Backbone, Marionette, $, _) ->
  class Entities.ShoeMeta extends Backbone.Model
    initialize: (game) ->
      console.log game
      # window.foo = game
      # {
      #   title: "#{} #{game.get('name')} #{game.get('brand').name} - Busca Sapato",
      #   metaDescription: game.description
      # }