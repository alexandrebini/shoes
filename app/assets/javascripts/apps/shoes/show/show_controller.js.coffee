@Shoes.module 'ShoesApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends App.Controllers.Base
    initialize: (slug) ->
      shoe = App.request('shoe:entity', slug)

      @layout = @getLayoutView(shoe)

      @listenTo @layout, 'show', =>
        @titleRegion shoe

      @show @layout,
        region: App.shoeRegion
        entities: shoe

    getLayoutView: (shoe) ->
      new Show.Layout(model: shoe)

    titleRegion: (shoe) ->
      titleView = @getTitleView(shoe)
      @layout.titleRegion.show titleView

    getTitleView: (shoe) ->
      new Show.Title
        model: shoe