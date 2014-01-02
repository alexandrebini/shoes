@Shoes.module 'HeaderApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends Marionette.Controller
    initialize: ->
      @headerRegion()

    headerRegion: ->
      App.headerRegion.show @getHeaderView()

    getHeaderView: ->
      new Show.Header()