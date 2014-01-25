@Shoes.module 'HeaderApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends Marionette.Controller
    initialize: ->
      @layout = @getLayoutView()
      App.headerRegion.show @layout
      @page = new App.PageChanger.Changer()

    getLayoutView: ->
      new Show.Layout

    logoRegion: (hasH1) ->
      @hasH1 = hasH1
      @logoView = @getLogoView()

      @listenTo @logoView, 'logo:clicked', =>
        App.vent.trigger 'visit:home'

      @layout.logoRegion.show @logoView

    getLogoView: () ->
      if @hasH1
        new Show.LogoH1
      else
        new Show.Logo