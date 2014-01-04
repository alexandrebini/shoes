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

   priceRegion: (shoe) ->
      console.log '--------------'
      priceView = @getPriceView(shoe)
      @layout.getPriceView.show priceView

    getPriceView: (shoe) ->
      new Show.Price
        model: shoe

    descriptionRegion: (shoe) ->
      descriptionView = @getDescriptionView(shoe)
      @layout.descriptionRegion.show descriptionView

    getDescriptionView: (shoe) ->
      new Show.Description
        model: shoe