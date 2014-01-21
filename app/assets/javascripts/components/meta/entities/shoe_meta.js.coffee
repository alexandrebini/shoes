@Shoes.module 'Components.ShoeMeta.Entities', (Entities, App, Backbone, Marionette, $, _) ->
  class Entities.ShoeMeta extends Backbone.Model
    defaults:
      title: undefined
      metaDescription: undefined

    parse: (shoe) ->
      @set
        title: "#{ shoe.get('category').name } #{ shoe.get('name') } #{ shoe.get('brand').name } - Busca Sapato",
        metaDescription: shoe.get('description')