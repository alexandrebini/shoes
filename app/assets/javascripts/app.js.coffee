@Shoes = do (Backbone, Marionette) ->
  App = new Marionette.Application

  App.on 'initialize:before', (options) ->
    App.environment = options.environment
    App.isSearchEngine = options.isSearchEngine

  App.on 'initialize:after', ->
    @startHistory()

  App.vent.on 'throw:error', (status) ->
    new App.Components.Error.Controller(status)

  App.addRegions
    navRegion: 'nav'
    headerRegion: 'header'
    mainRegion: 'article.list'
    shoeRegion: 'article.shoe'

  App.addInitializer (options) ->
    App.module('HeaderApp').start()
    App.module('NavApp').start()
    App.module('ShoesApp').start()
    App.module('CategoriesApp').start()
    App.module('BrandsApp').start(options.brandsSlugs)
    App.module('MetasApp').start()

  App