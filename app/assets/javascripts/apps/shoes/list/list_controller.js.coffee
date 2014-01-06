@Shoes.module 'ShoesApp.List', (List, App, Backbone, Marionette, $, _) ->
  class List.Controller extends Marionette.Controller
    initialize: (page) ->
      @shoes = App.request('shoes:entities', page)

      @layout = @getLayoutView()

      @listenTo @layout, 'show', =>
        @topPaginationRegion(@shoes)
        @shoesRegion(@shoes)
        @bottomPaginationRegion(@shoes)

      App.mainRegion.show @layout
      App.vent.on 'scroll:bottom', @getNextPage, @
      App.vent.on 'scroll:top', @getPreviousPage, @

    shoesRegion: (shoes) ->
      shoesView = @getShoesView(shoes)
      @layout.shoesRegion.show shoesView
      @listenTo shoesView, 'itemview:scroll:matches', (child, args) =>
        App.vent.trigger 'page:change', child.model.page

    topPaginationRegion: (shoes) ->
      paginationView = @getTopPaginationView(shoes)
      @layout.topPaginationRegion.show paginationView

    bottomPaginationRegion: (shoes) ->
      paginationView = @getBottomPaginationView(shoes)
      @layout.bottomPaginationRegion.show paginationView

    getShoesView: (shoes) ->
      new List.Shoes
        collection: shoes

    getTopPaginationView: (shoes) ->
      new App.Components.Pagination.View.TopPagination
        model: shoes.state

    getBottomPaginationView: (shoes) ->
      new App.Components.Pagination.View.BottomPagination
        model: shoes.state

    getLayoutView: ->
      new List.Layout

    getNextPage: ->
      @shoes.getNextPage()

    getPreviousPage: ->
      @shoes.getPreviousPage()