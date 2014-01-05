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
      @getShoesView(shoes)
      @layout.shoesRegion.show @shoesView

    topPaginationRegion: (shoes) ->
      paginationView = @getTopPaginationView(shoes)
      @layout.topPaginationRegion.show paginationView

    bottomPaginationRegion: (shoes) ->
      paginationView = @getBottomPaginationView(shoes)
      @layout.bottomPaginationRegion.show paginationView

    getShoesView: (shoes) ->
      @shoesView = new List.Shoes
        collection: shoes

      App.vent.trigger 'scroll:matcher:watch', @shoes
      App.vent.on 'scroll:matcher:matches', @shoes, @

    getTopPaginationView: (shoes) ->
      new App.Components.Pagination.View.TopPagination
        model: shoes.state

    getBottomPaginationView: (shoes) ->
      new App.Components.Pagination.View.BottomPagination
        model: shoes.state

    getLayoutView: ->
      new List.Layout

    getNextPage: ->
      if nextPage = @shoes.getNextPage()
        App.vent.trigger 'page:change', nextPage

    getPreviousPage: ->
      if previousPage = @shoes.getPreviousPage()
        App.vent.trigger 'page:change', previousPage

    changePage: (options) ->
      console.log 'change page'
      # visiblePage = @shoesView.visiblePage(scrollTop)