@Shoes.module 'Components.HomeMeta.Entities', (Entities, App, Backbone, Marionette, $, _) ->
  class Entities.HomeMeta extends Backbone.Model
    defaults:
      title: undefined
      metaDescription: undefined

    parse: (home) ->
      console.log home
      @set
        title: "Busca sapato ",
        metaDescription: "Encontre "

    categoriesJoin: ->
      'foo'

    brandsJoin: ->
      'bar'