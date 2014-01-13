@Shoes.module 'HeaderApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends Marionette.Controller
    initialize: ->
      @layout = @getLayoutView()

      App.headerRegion.show @layout

      @logoRegion()
      @listRegion()
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

    listRegion: ->
      getListRegion = @getListRegion()

      @listenTo getListRegion, 'toggle:list', =>
        console.log 'esconder a lista'

      @layout.listRegion.show getListRegion

    getListRegion: ->
      new Show.List()
