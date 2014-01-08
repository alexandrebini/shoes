@Shoes.module 'NavApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends Marionette.Controller
    initialize: ->
      @headerRegion()

    headerRegion: ->
      App.navRegion.show @getNavView()

    getNavView: ->
      new Show.Nav()