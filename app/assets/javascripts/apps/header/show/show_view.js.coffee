@Shoes.module 'HeaderApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends Marionette.Layout
    template: 'header/show/templates/show_layout'

    regions:
      listRegion: '.list'
      logoRegion: '.logo'

  class Show.Logo extends Marionette.ItemView
    template: 'header/show/templates/logo'
    className: 'header--logo'

    triggers:
      'click a' : 'logo:clicked'

  class Show.LogoH1 extends Marionette.ItemView
    template: 'header/show/templates/logo_h1'
    className: 'header--logo'

    triggers:
      'click a' : 'logo:clicked'