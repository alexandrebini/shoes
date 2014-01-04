@Shoes.module 'ShoesApp.List', (List, App, Backbone, Marionette, $, _) ->
  class List.Controller extends Marionette.Controller
    initialize: (page) ->
      @shoes = App.request('shoes:entities', page)
      App.vent.on 'scroll:bottom', @getNextPage, @
      App.vent.on 'scroll:top', @getPreviousPage, @

      window.a = @shoes
      @layout = @getLayoutView()

      @listenTo @layout, 'show', =>
        @shoesRegion(@shoes)

      App.mainRegion.show @layout

    shoesRegion: (shoes) ->
      shoesView = @getShoesView(shoes)
      @layout.shoesRegion.show shoesView

    getShoesView: (shoes) ->
      new List.Shoes
        collection: shoes

    getLayoutView: ->
      new List.Layout

    getNextPage: ->
      console.log 'getnextPage', @shoes.nextPage()
      if nextPage = @shoes.getNextPage()
        App.vent.trigger 'page:change', nextPage

    getPreviousPage: ->
      console.log 'getPreviousPage', @shoes.previousPage()
      if previousPage = @shoes.getPreviousPage()
        App.vent.trigger 'page:change', previousPage