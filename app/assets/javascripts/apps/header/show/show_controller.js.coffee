@Shoes.module 'HeaderApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends Marionette.Controller
    initialize: ->
      @layout = @getLayoutView()
      App.headerRegion.show @layout
      @model = App.request 'header:entity'

    getLayoutView: ->
      new Show.Layout

    logoRegion: (options) ->
      @hasH1 = options.hasH1
      @logoView = @getLogoView()

      @listenTo @logoView, 'logo:clicked', (args) =>
        App.vent.trigger 'visit', { route: args.model.get('logoPath'), visit: true }

      @layout.logoRegion.show @logoView

    getLogoView: () ->
      if @hasH1
        new Show.LogoWithHeading
          model: @model
      else
        new Show.LogoWithoutHeading
          model: @model