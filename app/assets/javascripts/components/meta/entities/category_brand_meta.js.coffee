@Shoes.module 'Components.CategoryBrandMeta.Entities', (Entities, App, Backbone, Marionette, $, _) ->
  class Entities.CategoryBrandMeta extends App.Components.MetaBase.Entities.MetaBase
    parse: (category, brand, shoes) ->
      @set
        title: "#{ category.get('name') } #{ brand.get('name') } - Busca Sapato",
        metaDescription: "#{ category.get('name') } #{ brand.get('name') } #{ @modelsNamesJoin(shoes) }"