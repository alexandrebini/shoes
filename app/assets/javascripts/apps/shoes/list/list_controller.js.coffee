@Shoes.module 'ShoesApp.List', (List, App, Backbone, Marionette, $, _) ->
  class List.Controller extends App.Components.ShoesList.Controller
    initialize: (page) ->
      App.vent.trigger 'set:header:headings'
      shoes = App.request('shoes:entities', page)
      super(shoes)