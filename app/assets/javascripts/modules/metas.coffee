@Shoes.module 'Metas', (Metas, App, Backbone, Marionette, $, _) ->
  class Metas.Insert
    @getInstance: ->
      @_instance ?= new @(arguments...)

    metaDescription: (description) ->
      $("meta[name='description']").remove()
      $('head').append $('<meta>', { content: description, name: 'description' })

    title: (title) ->
      $(document).attr 'title', title

  API =
    set: (obj) ->
      Metas.Insert.getInstance().metaDescription(obj.description)
      Metas.Insert.getInstance().metaDescription(obj.title)

  App.vent.on 'set:metas', (obj) ->
    API.set(obj)