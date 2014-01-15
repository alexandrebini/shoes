@Shoes.module 'ShoesApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends Marionette.Layout
    template: 'shoes/show/templates/show_layout'

    regions:
      mainPhotoRegion: 'section.shoe-photos .main'
      thumbRegion: 'section.shoe-photos .thumbs_container'
      titleRegion: 'section.shoe-description .title'
      priceRegion: 'section.shoe-description .price'
      descriptionRegion: 'section.shoe-description .description'
      numberRegion: 'section.shoe-description .grid'
      brandRegion: 'section.shoe-description .brand'
      buttonRegion: 'section.shoe-description .button'

    initialize: ->
      new App.ResizeComponent.Component(@)

  class Show.Thumb extends Marionette.ItemView
    template: 'shoes/show/templates/thumb'
    tagName: 'li'
    className: 'thumb'

    triggers:
      'click' : 'change:mainPhoto'

    modelEvents:
      'change:isSelected' : 'toggleSelected'

    toggleSelected: ->
      klass = 'is-shoe-thumb-selected'
      if @model.get('isSelected')
        @$el.addClass(klass)
      else
        @$el.removeClass(klass)

  class Show.Thumbs extends Marionette.CollectionView
    itemView: Show.Thumb
    tagName: 'ul'
    className: 'thumbs'

  class Show.MainPhoto extends Marionette.ItemView
    template: 'shoes/show/templates/main_photo'

    modelEvents:
      'change' : 'changeMainPhoto'

    changeMainPhoto: ->
      @$el.fadeOut =>
        @render @model

    onRender: ->
      @$el.hide().fadeIn =>
        App.vent.trigger 'resize:main:photo'

  class Show.Title extends Marionette.ItemView
    template: 'shoes/show/templates/title'
    templateHelpers: App.UrlHelper.Helper.getInstance()

  class Show.Price extends Marionette.ItemView
    template: 'shoes/show/templates/price'

  class Show.Description extends Marionette.ItemView
    template: 'shoes/show/templates/description'

  class Show.Brand extends Marionette.ItemView
    template: 'shoes/show/templates/brand'
    templateHelpers: App.UrlHelper.Helper.getInstance()
    triggers:
      'click a' : 'logo:clicked'

  class Show.Number extends Marionette.ItemView
    template: 'shoes/show/templates/number'
    tagName: 'li'
    className: ->
      "number #{ @model.get('className') }"

  class Show.Grid extends Marionette.CollectionView
    itemView: Show.Number
    tagName: 'ul'

  class Show.Button extends Marionette.ItemView
    template: 'shoes/show/templates/button'
    className: 'button-group'