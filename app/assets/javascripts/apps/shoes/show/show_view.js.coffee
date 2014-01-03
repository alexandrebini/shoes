@Shoes.module 'ShoesApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends Marionette.Layout
    template: 'shoes/show/templates/show_layout'
    id: 'shoe'

    regions:
      mainPhotoRegion: '.main_photo'
      thumbsRegion: '.thumbs'
      titleRegion: '.title'
      priceRegion: '.price'
      descriptionRegion: '.description'
      numberRegion: '.number'
      brandRegion: '.brandRegion'
      visitLinkRegion: '.visit_link'
      loveRegion: '.love_link'

    onShow: ->
      console.log @el

  class Show.Title extends Marionette.ItemView
    template: 'shoes/show/templates/title'
