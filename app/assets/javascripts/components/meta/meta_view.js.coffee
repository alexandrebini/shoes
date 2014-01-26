@Shoes.module 'Components.Meta.View', (View, App, Backbone, Marionette, $, _) ->
  class View.Title
    @getInstance: -> @_instance ?= new @(arguments...)

    ui:
      title: $('title')

    set: (title) ->
      @ui.title.text(title)

  class View.MetaDescription
    @getInstance: ->
      @_instance ?= new @(arguments...)

    ui:
      meta: $("meta[name='description']")

    set: (metaDescription) ->
      @ui.meta.attr('content', metaDescription)