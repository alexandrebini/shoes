@Shoes.module 'Components.CategoryMeta.Entities', (Entities, App, Backbone, Marionette, $, _) ->
  class Entities.CategoryMeta extends Backbone.Model
    parse: (category) ->
      @set
        title: "#{ category.get('name') } - Busca Sapato",
        metaDescription: category.get('meta_description')