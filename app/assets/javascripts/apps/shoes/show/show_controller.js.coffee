@Shoes.module 'ShoesApp.Show', (Show, App, Backbone, Marionette, $, _) ->
  class Show.Controller extends Marionette.Controller
    initialize: (slug) ->
      shoe = App.request('shoe:entity', slug)
      @layout = @getLayoutView()

      App.execute 'when:fetched', shoe, =>
        App.shoeRegion.show @layout

      @listenTo @layout, 'show', =>
        @thumbRegion(shoe)
        @titleRegion(shoe)
        @priceRegion(shoe)
        @descriptionRegion(shoe)
        @brandRegion(shoe)
        @numberRegion(shoe)
        @buttonRegion(shoe)

      Show.on 'set:mainPhoto', (photo) =>
        @mainPhotoRegion photo

    getLayoutView: ->
      new Show.Layout

    thumbRegion: (shoe) ->
      thumbView = @getThumbView(shoe)

      @listenTo thumbView, 'itemview:change:mainPhoto', (child, args) =>
        @mainPhotoRegion args.model

      @layout.thumbRegion.show thumbView


    getThumbView: (shoe) ->
      new Show.Images
        collection: shoe.images

    mainPhotoRegion: (photo) ->
      mainPhotoView = @getMainPhotoView(photo)
      @layout.mainPhotoRegion.show mainPhotoView

    getMainPhotoView: (photo) ->
      new Show.MainPhoto
        model: photo

    titleRegion: (shoe) ->
      titleView = @getTitleView(shoe)
      @layout.titleRegion.show titleView

    getTitleView: (shoe) ->
      new Show.Title
        model: shoe

    priceRegion: (shoe) ->
      priceView = @getPriceView(shoe)
      @layout.priceRegion.show priceView

    getPriceView: (shoe) ->
      new Show.Price
        model: shoe

    descriptionRegion: (shoe) ->
      descriptionView = @getDescriptionView(shoe)
      @layout.descriptionRegion.show descriptionView

    getDescriptionView: (shoe) ->
      new Show.Description
        model: shoe

    brandRegion: (shoe) ->
      brandView = @getBrandView(shoe)
      @layout.brandRegion.show brandView

    getBrandView: (shoe) ->
      new Show.Brand
        model: shoe

    numberRegion: (shoe) ->
      numberView = @getNumberView(shoe)
      @layout.numberRegion.show numberView

    getNumberView: (shoe) ->
      new Show.Grid
        collection: shoe.numerations

    buttonRegion: (shoe) ->
      buttonView = @getButtonView(shoe)
      @layout.buttonRegion.show buttonView

    getButtonView: (shoe) ->
      new Show.Button
        model: shoe