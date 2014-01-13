@Shoes.module 'HeaderApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends Marionette.Layout
    template: 'header/show/templates/show_layout'

    regions:
      listRegion: '.list'
      logoRegion: '.logo'

  class Show.List extends Marionette.ItemView
    template: 'header/show/templates/list'
    className: 'header--list'

    triggers:
      'click' : 'toggle:list'

  class Show.Logo extends Marionette.ItemView
    template: 'header/show/templates/logo'
    className: 'header--logo'
    tagName: 'h1'

    triggers:
      'click' : 'home:back'