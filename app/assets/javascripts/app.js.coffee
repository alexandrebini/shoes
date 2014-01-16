@Shoes = do (Backbone, Marionette) ->
  App = new Marionette.Application

  App.on 'initialize:before', (options) ->
    App.environment = options.environment

  App.on 'initialize:after', ->
    @startHistory()

  App.addRegions
    navRegion: 'nav'
    headerRegion: 'header'
    mainRegion: 'article.list'
    shoeRegion: 'article.shoe'

  App.addInitializer (options) ->
    App.module('HeaderApp').start()
    App.module('ShoesApp').start()
    App.module('CategoriesApp').start()
    App.module('BrandsApp').start(options.brandsSlugs)
  App