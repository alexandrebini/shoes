@Shoes.module 'Components.BrandMeta.Entities', (Entities, App, Backbone, Marionette, $, _) ->
  class Entities.BrandMeta extends Backbone.Model
    parse: (brand) ->
      @set
        title: "#{ brand.get('name') } - Busca Sapato",
        metaDescription: brand.get('meta_description')