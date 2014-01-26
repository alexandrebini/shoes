@Shoes.module 'Components.ShoesList', (ShoesList, App, Backbone, Marionette, $, _) ->
  class ShoesList.Controller extends Marionette.Controller
    initialize: (shoes) ->
      @shoes = shoes
      @layout = @getLayoutView()

      @listenTo @layout, 'show', =>
        App.execute 'when:fetched', @shoes, =>
          @topPaginationRegion(@shoes)
          @shoesRegion(@shoes)
          @bottomPaginationRegion(@shoes)

      @enable()
      App.vent.on 'scroll:bottom', @getNextPage, @
      App.vent.on 'scroll:top', @getPreviousPage, @

    shoesRegion: (shoes) ->
      shoesView = @getShoesView(shoes)
      @layout.shoesRegion.show shoesView
      @listenTo shoesView, 'itemview:itemview:itemview:shoe:clicked', (page, group, shoe) =>
        App.vent.trigger 'visit:shoe', shoe.model.get('slug')

      @listenTo shoesView, 'itemview:scroll:matches', (child, args) =>
        App.vent.trigger 'page:change', child.model.page

    topPaginationRegion: (shoes) ->
      paginationView = @getTopPaginationView(shoes)
      @layout.topPaginationRegion.show paginationView

    bottomPaginationRegion: (shoes) ->
      paginationView = @getBottomPaginationView(shoes)
      @layout.bottomPaginationRegion.show paginationView

    getShoesView: (shoes) ->
      new ShoesList.View.Shoes
        collection: shoes

    getTopPaginationView: (shoes) ->
      new App.Components.Pagination.View.TopPagination
        model: shoes.state

    getBottomPaginationView: (shoes) ->
      new App.Components.Pagination.View.BottomPagination
        model: shoes.state

    getLayoutView: ->
      new ShoesList.View.Layout

    getNextPage: ->
      @shoes.getNextPage()

    getPreviousPage: ->
      @shoes.getPreviousPage()

    enable: ->
      App.mainRegion.show @layout
      App.mainRegion.$el.show()

    disable: ->
      @layout.close()
      App.mainRegion.$el.hide()