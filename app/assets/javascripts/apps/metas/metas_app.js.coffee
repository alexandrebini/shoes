@Shoes.module 'MetasApp', (MetasApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  API =
    metas: (options) ->
      new MetasApp.Meta.Controller(options)

  App.vent.on 'shoe:visited', (shoe) ->
    shoe = new Shoes.Components.ShoeMeta.Entities.ShoeMeta().parse(shoe)
    API.metas(shoe)