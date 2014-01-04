@Shoes.module 'ShoesApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends Marionette.Layout
    template: 'shoes/show/templates/show_layout'
    id: 'shoe'

    regions:
      mainPhotoRegion: '.main'
      thumbRegion: '.thumbs_container'
      titleRegion: '.title'
      priceRegion: '.price'
      descriptionRegion: '.description'
      numberRegion: '.number'
      brandRegion: '.brand'
      buttonRegion: '.button'

  class Show.Thumb extends Marionette.ItemView
    template: 'shoes/show/templates/thumb'
    tagName: 'li'
    className: 'thumb'

    initialize: ->
      Show.trigger 'set:mainPhoto', @model if @model.get('main')

    triggers:
      'click' : { event: 'change:mainPhoto', preventDefault: true }

  class Show.Images extends Marionette.CollectionView
    itemView: Show.Thumb
    tagName: 'ul'
    className: 'thumbs'

  class Show.MainPhoto extends Marionette.ItemView
    template: 'shoes/show/templates/main_photo'

    onShow: ->
      @$el.hide().fadeIn()

    onClose: ->
      @$el.fadeOut()

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

  class Show.Grid extends Marionette.CollectionView
    itemView: Show.Number
    tagName: 'ul'

  class Show.Button extends Marionette.ItemView
    template: 'shoes/show/templates/button'
    className: 'button-group'