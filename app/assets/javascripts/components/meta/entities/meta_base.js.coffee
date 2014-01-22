@Shoes.module 'Components.MetaBase.Entities', (Entities, App, Backbone, Marionette, $, _) ->
  class Entities.MetaBase extends Backbone.Model
    modelsNamesJoin: (models) ->
      models = models.models
      lastName = models.pop().get('name')
      names = ''

      unless models
        names = _.map(models, (model) ->
          return model.get('name')
        ).join(', ')

      "#{ names } e #{ lastName }"