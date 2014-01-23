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

    h1Add: ->
      content = @$el.html()
      @$el.html $('<h1>').append content

    h1Remove: ->
      content = @$el.find('h1').html()
      @$el.find('h1').remove()
      @$el.html content