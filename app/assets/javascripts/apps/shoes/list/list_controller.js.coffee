@Shoes.module 'ShoesApp.List', (List, App, Backbone, Marionette, $, _) ->
  class List.Controller extends App.Components.ShoesList.Controller
    initialize: (page) ->
      shoes = App.request('shoes:entities', page)
      App.vent.trigger 'set:header:headings'

      App.Metas.Insert.getInstance()
      App.vent.trigger 'set:metas', { title: 'Busca sapato', description: 'Encontre seu sapato.'}

      super(shoes)