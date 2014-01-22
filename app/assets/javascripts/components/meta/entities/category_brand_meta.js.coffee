@Shoes.module 'Components.CategoryBrandMeta.Entities', (Entities, App, Backbone, Marionette, $, _) ->
  class Entities.CategoryBrandMeta extends Backbone.Model
    defaults:
      title: undefined
      metaDescription: undefined

    parse: (category, brand, shoes) ->
      @set
        title: "#{ category.get('name') } da #{ brand.get('name') } - Busca Sapato",
        metaDescription: "Encontre #{ category.get('name') } da #{ brand.get('name') } #{ @shoesNames(shoes) }"

    shoesNames: (shoes) ->
      'fooo'