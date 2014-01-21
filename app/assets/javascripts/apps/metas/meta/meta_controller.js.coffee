@Shoes.module 'MetasApp.Meta', (Meta, App, Backbone, Marionette, $, _) ->
  class Meta.Controller extends Marionette.Controller
    initialize: (options) ->
      @setTitleView(options.title)

    setTitleView: (title) ->
      Meta.Title.getInstance().set(title)