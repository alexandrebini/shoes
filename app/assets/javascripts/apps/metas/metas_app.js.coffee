@Shoes.module 'MetasApp', (MetasApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  API =
    metas: (options) ->
      new MetasApp.Meta.Controller(options)

  App.vent.on 'shoe:visited', (shoe) ->
    # metas = new App.Components.ShoeMeta.Entities.ShoeMeta(shoe)
    # console.log metas

    API.metas({ title: 'foooo' })