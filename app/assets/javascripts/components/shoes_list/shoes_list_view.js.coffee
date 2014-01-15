@Shoes.module 'Components.ShoesList.View', (View, App, Backbone, Marionette, $, _) ->

  class View.Layout extends Marionette.Layout
    template: 'shoes_list/templates/list_layout'
    regions:
      topPaginationRegion: '.top'
      shoesRegion: 'article.shoes'
      bottomPaginationRegion: '.bottom'

  class View.Shoe extends Marionette.ItemView
    templateHelpers: App.UrlHelper.Helper.getInstance()
    template: 'shoes_list/templates/shoe'
    className: ->
      className = "shoes--#{ @model.get('style') }"
      if @model.get('orientation')
        className += " is-#{ @model.get('orientation') }"
      className

    triggers:
      'click a' : 'shoe:clicked'

  class View.ShoesGroup extends Marionette.CollectionView
    itemView: View.Shoe
    className: 'shoes--box'

    initialize: ->
      @collection = @model

  class View.ShoesPage extends App.Components.Pagination.View.Page
    itemView: View.ShoesGroup
    tagName: 'section'

  class View.Shoes extends App.Components.Pagination.View.Pages
    itemView: View.ShoesPage