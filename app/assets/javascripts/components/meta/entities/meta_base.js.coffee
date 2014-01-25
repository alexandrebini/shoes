@Shoes.module 'Components.MetaBase.Entities', (Entities, App, Backbone, Marionette, $, _) ->
  class Entities.MetaBase extends Backbone.Model
    modelsNamesJoin: (collection) ->
      models = collection.models
      lastName = models.pop().get('name')
      names = ''

      unless _.isEmpty(models)
        names = _.map(models, (model) ->
          return model.get('name')
        ).join(', ')

      "#{ names } e #{ lastName }"

    getShoes: (shoesGroupsCollections) ->
      shoes = _.map(shoesGroupsCollections, (collection) -> collection.models)
      { models: _.flatten(shoes) }