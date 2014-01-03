@Shoes.module 'Controllers', (Controllers, App, Backbone, Marionette, $, _) ->

  class Controllers.Base extends Marionette.Controller
    show: (view, options = {}) ->
      _.defaults options,
        loading: false
        region: App.mainRegion
      @_setMainView view
      @_manageView view, options

    _setMainView: (view) ->
      return if @_mainView
      @_mainView = view
      @listenTo view, 'close', @close

    _manageView: (view, options) ->
      if options.loading
        App.execute 'show:loading', view, options
      else
        options.region.show view