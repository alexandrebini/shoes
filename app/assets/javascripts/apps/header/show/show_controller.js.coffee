@Shoes.module 'HeaderApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends Marionette.Controller
    initialize: ->
      @layout = @getLayoutView()

      App.headerRegion.show @layout

      @logoRegion()
      @page = new App.PageChanger.Changer()

    logoRegion: ->
      @logoView = @getLogoView()

      @listenTo @logoView, 'logo:clicked', =>
        App.vent.trigger 'visit:home'

      @layout.logoRegion.show @logoView

    getLayoutView: ->
      new Show.Layout

    getLogoView: ->
      new Show.Logo

    setH1View: ->
      @logoView.h1Add()

    removeH1View: ->
      @logoView.h1Remove()