@Shoes.module 'Components.Pagination.View', (View, App, Backbone, Marionette, $, _) ->

  class View.Page extends Marionette.CollectionView
    className: 'page'
    initialize: ->
      @collection = @model

  class View.Pagination extends Marionette.CompositeView
    template: 'pagination/templates/pagination'
    itemViewContainer: '.shoes'

    initialize: ->
      @model = @collection.state
      console.log @renderModel
      # @model.on 'change', @renderModel, @
      @model.on 'change', @foo, @

    foo: ->
      console.log @renderModel()

