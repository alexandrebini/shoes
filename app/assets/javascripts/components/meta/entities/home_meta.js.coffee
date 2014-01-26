@Shoes.module 'Components.HomeMeta.Entities', (Entities, App, Backbone, Marionette, $, _) ->
  class Entities.HomeMeta extends Backbone.Model
    @getInstance: -> @_instance ?= new @(arguments...)

    parse: (categories, brands) ->
      @set
        title: "Busca sapato - #{ @parseModelsName(brands) } ",
        metaDescription: "Encontre #{ @parseModelsName(categories) }"

    parseModelsName: (models) ->
      models.map( (data) ->
        data.get('name')
      ).toSentence()