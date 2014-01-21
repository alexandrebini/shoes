@Shoes.module 'MetasApp.Meta', (Meta, App, Backbone, Marionette, $, _) ->
  class Meta.Title
    @getInstance: ->
      @_instance ?= new @(arguments...)

    ui:
      title: $('title')

    set: (title) ->
      @ui.title.html(title)

  class Meta.MetaDescription
    @getInstance: ->
      @_instance ?= new @(arguments...)

    ui:
      meta: $("meta[name='description']")

    set: (metaDescription) ->
      @ui.meta.attr('content', metaDescription)