@Shoes.module 'Components.CategoryBrandMeta.Entities', (Entities, App, Backbone, Marionette, $, _) ->
  class Entities.CategoryBrandMeta extends Backbone.Model
    @getInstance: -> @_instance ?= new @(arguments...)

    parse: (category, brand, shoesGroupsCollection) ->
      @shoesGroupsCollection = shoesGroupsCollection

      @set
        title: "#{ category.get('name') } #{ brand.get('name') } - Busca Sapato",
        metaDescription: "#{ category.get('name') } #{ brand.get('name') }: #{ @parseShoes() }"

    parseShoes: ->
      @shoesGroupsCollection[0].models.map( (model) ->
        model.get('name')
      ).toSentence()