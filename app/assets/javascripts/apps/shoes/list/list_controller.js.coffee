@Shoes.module 'ShoesApp.List', (List, App, Backbone, Marionette, $, _) ->
  class List.Controller extends App.Components.ShoesList.Controller
    initialize: (page) ->
      shoes = App.request('shoe:entities', page)
      super(shoes)