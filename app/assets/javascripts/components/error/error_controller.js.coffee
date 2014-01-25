@Shoes.module 'Components.Error', (Error, App, Backbone, Marionette, $, _) ->
  class Error.Controller extends Marionette.Controller
    initialize: (status) ->
      @layout = @getLayoutView()

      @listenTo @layout, 'show', =>
        @errorRegion status

      @show @layout

    errorRegion: (status) ->
      errorView = @getErrorView(status)

      @listenTo errorView, 'error:button:clicked', ->
        App.vent.trigger 'visit:home'

      @layout.errorRegion.show errorView

    getLayoutView: (game) ->
      new Error.Layout

    getErrorView: (status) ->
      if status == 404
        return new Error.NotFound
      else
        return new Error.InternalError

    onClose: ->
      @layout.close()
