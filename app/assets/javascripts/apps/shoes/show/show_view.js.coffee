@Shoes.module 'ShoesApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends Marionette.Layout
    template: 'shoes/show/templates/show_layout'

    regions:
      mainPhotoRegion: 'section.photos--box .main'
      thumbRegion: 'section.photos--box .thumbs_container'
      titleRegion: 'section.description--box .title'
      priceRegion: 'section.description--box .price'
      descriptionRegion: 'section.description--box .description'
      numberRegion: 'section.description--box .number'
      brandRegion: 'section.description--box .brand'
      buttonRegion: 'section.description--box .button'

  class Show.Thumb extends Marionette.ItemView
    template: 'shoes/show/templates/thumb'
    tagName: 'li'
    className: 'thumb--box'

    triggers:
      'click' : { event: 'change:mainPhoto', preventDefault: true }

  class Show.Thumbs extends Marionette.CollectionView
    itemView: Show.Thumb
    tagName: 'ul'
    className: 'thumbs'

  class Show.MainPhoto extends Marionette.ItemView
    template: 'shoes/show/templates/main_photo'

    modelEvents:
      'change' : 'changeMainPhoto'

    changeMainPhoto: ->
      @render @model

    onRender: ->
      @$el.hide().fadeIn()

  class Show.Title extends Marionette.ItemView
    template: 'shoes/show/templates/title'

  class Show.Price extends Marionette.ItemView
    template: 'shoes/show/templates/price'

  class Show.Description extends Marionette.ItemView
    template: 'shoes/show/templates/description'

  class Show.Brand extends Marionette.ItemView
    template: 'shoes/show/templates/brand'

  class Show.Number extends Marionette.ItemView
    template: 'shoes/show/templates/number'
    tagName: 'li'
    className: ->
      "grid--box #{ @model.get('className') }"

  class Show.Grid extends Marionette.CollectionView
    itemView: Show.Number
    tagName: 'ul'

  class Show.Button extends Marionette.ItemView
    template: 'shoes/show/templates/button'
    className: 'button-group'