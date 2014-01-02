@Shoes.module 'ShoesApp.List', (List, App, Backbone, Marionette, $, _) ->
  class List.Controller extends Marionette.Controller
    initialize: ->
      shoes = App.request('shoes:entities')
      @layout = @getLayoutView()

      @listenTo @layout, 'show', =>
        @shoesRegion(shoes)

      App.mainRegion.show @layout

    shoesRegion: (shoes) ->
      shoesView = @getShoesView(shoes)
      @layout.shoesRegion.show shoesView

    getShoesView: (shoes) ->
      new List.Shoes
        collection: shoes

    getLayoutView: ->
      new List.Layout