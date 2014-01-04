@Shoes.module 'Components.Pagination.View', (View, App, Backbone, Marionette, $, _) ->

  class View.Page extends Marionette.CollectionView
    className: 'page'
    initialize: ->
      @collection = @model