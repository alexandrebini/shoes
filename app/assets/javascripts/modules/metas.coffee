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
      Metas.Insert.getInstance().title(obj.title)

  App.vent.on 'shoe:visited', (shoe) ->
    metas = new App.Components.ShoeMeta.Entities.ShoeMeta(shoe)
    console.log metas, '------------- metas ----------'