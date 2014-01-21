@Shoes.module 'Components.ShoeMeta.Entities', (Entities, App, Backbone, Marionette, $, _) ->
  class Entities.ShoeMeta extends Backbone.Model
    defaults:
      title: undefined
      metaDescription: undefined

    parse: (shoes) ->
      @set
        title: "Busca sapato ",
        metaDescription: "Encontre "

    categoriesJoin:

    brandsJoin: