@Shoes.module 'Components.Pagination.View', (View, App, Backbone, Marionette, $, _) ->

  class View.Pages extends Marionette.CollectionView

    appendHtml: (collectionView, itemView, index) ->
      return collectionView.$el.insertAt(index, itemView.$el)

  class View.Page extends Marionette.CollectionView
    className: 'page'
    initialize: ->
      @collection = @model

  class View.Pagination extends Marionette.ItemView
    template: 'pagination/templates/pagination'

    constructor: (options) ->
      @position = options.position
      @model = options.model
      super()

    serializeData: ->
      { position: @position, isLoading: @model.get('isLoading') }

    className: ->
      console.log 'classname'
      className = ['pagination']
      switch @position
        when 'top'
          if @model.get('isLoading') && @model.get('direction') == 'up'
            className.push 'is-loading'
          else if @model.get('page') == 0
            className.push 'is-hidden'
        when 'bottom'
          if @model.get('isLoading') && @model.get('direction') == 'down'
            className.push 'is-loading'
          else if @model.get('page') == @model.get('totalPages')
            className.push 'is-hidden'
      className.join(' ')