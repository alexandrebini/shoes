@Shoes.module 'Components.Meta', (Meta, App, Backbone, Marionette, $, _) ->
  class Meta.Controller extends Marionette.Controller
    @getInstance: -> @_instance ?= new @(arguments...)

    set: (metas) ->
      @setTitleView(metas.get('title'))
      @setMetaDescriptionView(metas.get('metaDescription'))

    setTitleView: (title) ->
      App.Components.Meta.View.Title.getInstance().set(title)

    setMetaDescriptionView: (metaDescription) ->
      App.Components.Meta.View.MetaDescription.getInstance().set(metaDescription)