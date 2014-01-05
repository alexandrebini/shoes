@Shoes.module 'ShoesApp.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends Marionette.Layout
    template: 'shoes/list/templates/list_layout'
    regions:
      shoesRegion: 'article.shoes'

  class List.Shoe extends Marionette.ItemView
    template: 'shoes/list/templates/shoe'
    className: ->
      className = "shoes--#{ @model.get('style') }"
      if @model.get('orientation')
        className += " is-#{ @model.get('orientation') }"
      className

  class List.ShoesGroup extends Marionette.CollectionView
    itemView: List.Shoe
    className: 'shoes--box'

    initialize: ->
      @collection = @model

  class List.ShoesPage extends App.Components.Pagination.View.Page
    itemView: List.ShoesGroup
    tagName: 'section'

  class List.Shoes extends App.Components.Pagination.View.Pagination
    itemView: List.ShoesPage