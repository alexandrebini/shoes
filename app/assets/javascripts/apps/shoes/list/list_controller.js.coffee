@Shoes.module 'ShoesApp.List', (List, App, Backbone, Marionette, $, _) ->
  class List.Controller extends Marionette.Controller
    initialize: (page) ->
      @shoes = App.request('shoes:entities', page)
      App.vent.on 'scroll:bottom', @getNextPage, @
      App.vent.on 'scroll:top', @getPreviousPage, @

      window.a = @shoes
      @layout = @getLayoutView()

      @listenTo @layout, 'show', =>
        @topPaginationRegion(@shoes)
        @shoesRegion(@shoes)
        @bottomPaginationRegion(@shoes)

      App.mainRegion.show @layout

    shoesRegion: (shoes) ->
      shoesView = @getShoesView(shoes)
      @layout.shoesRegion.show shoesView

    topPaginationRegion: (shoes) ->
      paginationView = @getPaginationView(shoes, 'top')
      @layout.topPaginationRegion.show paginationView

    bottomPaginationRegion: (shoes) ->
      paginationView = @getPaginationView(shoes, 'bottom')
      @layout.bottomPaginationRegion.show paginationView

    getShoesView: (shoes) ->
      new List.Shoes
        collection: shoes

    getPaginationView: (shoes, position) ->
      new App.Components.Pagination.View.Pagination
        model: shoes.state
        position: position

    getLayoutView: ->
      new List.Layout

    getNextPage: ->
      console.log 'getnextPage', @shoes.nextPage()
      if nextPage = @shoes.getNextPage()
        App.vent.trigger 'page:change', nextPage

    getPreviousPage: ->
      if previousPage = @shoes.getPreviousPage()
        App.vent.trigger 'page:change', previousPage