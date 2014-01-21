@Shoes.module 'MetasApp.Meta', (Meta, App, Backbone, Marionette, $, _) ->
  class Meta.Title
    @getInstance: ->
      @_instance ?= new @(arguments...)

    ui:
      title: $('title')

    set: (title) ->
      @ui.title.html(title)