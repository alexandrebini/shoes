@Shoes.module 'HeaderApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends Marionette.Controller
    initialize: ->
      @layout = @getLayoutView()

      App.headerRegion.show @layout

      @logoRegion()
      @page = new App.PageChanger.Changer()

    getLayoutView: ->
      new Show.Layout

    logoRegion: ->
      getLogoRegion = @getLogoRegion()

      @listenTo getLogoRegion, 'home:back', =>
        @page.navigate('/', true)

      @layout.logoRegion.show getLogoRegion

    getLogoRegion: ->
      new Show.Logo()