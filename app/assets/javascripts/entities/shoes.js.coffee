@Shoes.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Shoe extends Backbone.Model
    urlRoot: -> Routes.shoes_path()
    idAttribute: 'slug'