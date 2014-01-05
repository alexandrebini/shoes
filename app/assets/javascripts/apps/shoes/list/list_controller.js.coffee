@Shoes.module 'ShoesApp.List', (List, App, Backbone, Marionette, $, _) ->
  class List.Controller extends Marionette.Controller
    initialize: (page) ->
      @shoes = App.request('shoes:entities', page)
      App.vent.on 'scroll:bottom', @getNextPage, @

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
      if nextPage = @shoes.getNextPage()
        App.vent.trigger 'page:change', nextPage