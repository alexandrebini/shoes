@Shoes.module 'ShoesApp.List', (List, App, Backbone, Marionette, $, _) ->
  class List.Controller extends App.Components.ShoesList.Controller
    initialize: (page) ->
      App.module('NavApp').start()
      shoes = App.request('shoes:entities', page)
      super(shoes)