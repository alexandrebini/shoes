@Shoes.module 'HeaderApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends Marionette.Layout
    template: 'header/show/templates/show_layout'

    regions:
      listRegion: '.list'
      logoRegion: '.logo'

  class Show.Logo extends Marionette.ItemView
    template: 'header/show/templates/logo'
    className: 'header--logo'

    initialize: ->
      App.vent.on 'set:header:headings', => @addH1()
      App.vent.on 'remove:header:headings', => @removeH1()

    triggers:
      'click' : 'home:back'

    events:
      'set:home:headings' : 'foo'

    addH1: ->
      h1 = $('<h1>').text('busca sapato')
      @$el.append(h1)

    removeH1: ->
      @$el.find('h1').remove()