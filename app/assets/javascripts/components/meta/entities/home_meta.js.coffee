@Shoes.module 'Components.HomeMeta.Entities', (Entities, App, Backbone, Marionette, $, _) ->
  class Entities.HomeMeta extends App.Components.MetaBase.Entities.MetaBase
    parse: (categories, brands) ->
      @set
        title: "Busca sapato - #{ @modelsNamesJoin(brands) } ",
        metaDescription: "Encontre #{ @modelsNamesJoin(categories) }"

