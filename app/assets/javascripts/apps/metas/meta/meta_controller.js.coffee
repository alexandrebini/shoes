@Shoes.module 'MetasApp.Meta', (Meta, App, Backbone, Marionette, $, _) ->
  class Meta.Controller extends Marionette.Controller
    initialize: (options) ->
      @setTitleView(options.get('title'))
      @setMetaDescriptionView(options.get('metaDescription'))

    setTitleView: (title) ->
      Meta.Title.getInstance().set(title)

    setMetaDescriptionView: (metaDescription) ->
      Meta.MetaDescription.getInstance().set(metaDescription)