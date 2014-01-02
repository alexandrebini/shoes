@Shoes.module 'ShoesApp.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends Marionette.Layout
    template: 'shoes/list/templates/list_layout'
    regions:
      shoesRegion: 'section'

  class List.Shoe extends Marionette.ItemView
    template: 'shoes/list/templates/shoe'

  class List.Shoes extends Marionette.CollectionView
    itemView: List.Shoe
