@Shoes.module 'Controllers', (Controllers, App, Backbone, Marionette, $, _) ->

  class Controllers.Base extends Marionette.Controller
    show: (view, options = {}) ->
      @_setMainView view
      @_manageView view, options

    _setMainView: (view) ->
      return if @_mainView
      @_mainView = view
      @listenTo view, 'close', @close

    _manageView: (view, options) ->
      options.region.show view
      App.execute 'when:fetched', options.entities, =>
        @show view,
          region: options.region