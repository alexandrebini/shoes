@Shoes.module 'HeaderApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends Marionette.Layout
    template: 'header/show/templates/show_layout'

    regions:
      listRegion: '.list'
      logoRegion: '.logo'

  class Show.Logo extends Marionette.ItemView
    template: 'header/show/templates/logo'
    tagName: 'h1'

    triggers:
      'click' : 'home:back'

  class Show.List extends Marionette.ItemView
    template: 'header/show/templates/list'

    triggers:
      'click' : 'toggle:list'