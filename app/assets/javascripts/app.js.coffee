@Shoes = do (Backbone, Marionette) ->
  App = new Marionette.Application

  App.on 'initialize:before', (options) ->
    App.environment = options.environment

  App.on 'initialize:after', ->
    @startHistory()

  App.addRegions
    headerRegion: 'header'
    mainRegion: 'article.list'
    shoeRegion: 'article.show'

  App.addInitializer (options) ->
    App.module('HeaderApp').start()
    App.module('BrandsApp').start(options.brandsSlugs)
    App.module('ShoesApp').start()

  App