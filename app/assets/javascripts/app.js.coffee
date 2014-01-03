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

  App.vent.on 'set:title', (title) ->
    App.setTitle "Shoes - #{ title }"

  App.vent.on 'set:full_title', (title) ->
    App.setTitle title

  App.vent.on 'scrollTop', ->
    App.scrollTop()

  App.vent.on 'set:meta_description', (content) ->
    App.setMetaDescription content

  App.vent.on 'set:facebook_meta', (metaTags) ->
    App.setFacebookMeta metaTags

  App