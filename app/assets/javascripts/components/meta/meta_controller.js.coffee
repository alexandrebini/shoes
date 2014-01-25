@Shoes.module 'Components.Meta', (Meta, App, Backbone, Marionette, $, _) ->
  class Meta.Controller extends Marionette.Controller
    initialize: (options) ->
      @setTitleView(options.get('title'))
      @setMetaDescriptionView(options.get('metaDescription'))

    setTitleView: (title) ->
      App.Components.Meta.View.Title.getInstance().set(title)

    setMetaDescriptionView: (metaDescription) ->
      App.Components.Meta.View.MetaDescription.getInstance().set(metaDescription)