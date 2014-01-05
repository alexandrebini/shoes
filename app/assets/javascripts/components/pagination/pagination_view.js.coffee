@Shoes.module 'Components.Pagination.View', (View, App, Backbone, Marionette, $, _) ->

  class View.Pages extends Marionette.CollectionView
    appendHtml: (collectionView, itemView, index) ->
      return collectionView.$el.insertAt(index, itemView.$el)

  class View.Page extends Marionette.CollectionView
    className: 'page'
    initialize: ->
      @collection = @model

  class View.TopPagination extends Marionette.ItemView
    template: 'pagination/templates/top_pagination'
    templateHelpers: App.UrlHelper.Helper.getInstance()
    modelEvents:
      'change:isLoading change:page change:direction': 'render'

  class View.BottomPagination extends Marionette.ItemView
    template: 'pagination/templates/bottom_pagination'
    templateHelpers: App.UrlHelper.Helper.getInstance()
    modelEvents:
      'change:isLoading change:page change:direction': 'render'