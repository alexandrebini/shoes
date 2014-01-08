@Shoes.module 'NavApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends Marionette.Layout
    template: 'nav/show/templates/layout'
    regions:
      categoriesRegion: 'section.categories'
      brandsRegion: 'section.brands'

  class Show.Category extends Marionette.ItemView
    tagName: 'li'
    template: 'nav/show/templates/category'

  class Show.Categories extends Marionette.CompositeView
    template: 'nav/show/templates/categories'
    itemView: Show.Category
    itemViewContainer: 'ul'

  class Show.Brand extends Marionette.ItemView
    tagName: 'li'
    template: 'nav/show/templates/brand'

  class Show.Brands extends Marionette.CompositeView
    template: 'nav/show/templates/brands'
    itemView: Show.Brand
    itemViewContainer: 'ul'