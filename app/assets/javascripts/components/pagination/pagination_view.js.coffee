@Shoes.module 'Components.Pagination.View', (View, App, Backbone, Marionette, $, _) ->

  class View.Page extends Marionette.CollectionView
    className: 'page'
    initialize: ->
      @collection = @model

  class View.Pagination extends Marionette.CompositeView
    template: 'pagination/templates/pagination'
    ui:
      pagination: '.pagination'

    initialize: ->
      @model = @collection.state
      @model.on 'change', @render, @

    appendHtml: (collectionView, itemView, index) ->
      @ui.pagination.before(itemView.el)