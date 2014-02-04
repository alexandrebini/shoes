@Shoes.module 'HeaderApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends Marionette.Layout
    template: 'header/show/templates/show_layout'

    regions:
      listRegion: '.list'
      logoRegion: '.logo'

  class Show.Logo extends Marionette.ItemView
    className: 'header--logo'
    triggers:
      'click a' : 'logo:clicked'

    modelEvents:
      'change:logoPath' : 'changePath'

    ui:
      logo: 'a.logo'

    changePath: ->
      @ui.logo.attr href: @model.get('logoPath')

  class Show.LogoWithoutHeading extends Show.Logo
    template: 'header/show/templates/logo'

  class Show.LogoWithHeading extends Show.Logo
    template: 'header/show/templates/logo_h1'