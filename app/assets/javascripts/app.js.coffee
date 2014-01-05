@Shoes = do (Backbone, Marionette) ->
  App = new Marionette.Application

  App.on 'initialize:before', (options) ->
    App.environment = options.environment

  App.on 'initialize:after', ->
    @startHistory()

  App.addRegions
    headerRegion: 'header'
    mainRegion: 'article.home'
    shoeRegion: 'article.shoe'

  App.addInitializer ->
    App.module('HeaderApp').start()
    App.module('ShoesApp').start()

  App