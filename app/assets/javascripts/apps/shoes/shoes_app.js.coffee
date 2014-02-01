@Shoes.module 'ShoesApp', (ShoesApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  class ShoesApp.Router extends Marionette.AppRouter
    appRoutes:
      '' : 'list'
      'pg-:page/' : 'list'
      ':category/:brand/:shoe/' : 'show'

  API =
    list: (page) ->
      @listController = new ShoesApp.List.Controller(page)
      App.vent.trigger 'home:visited'

    show: (category, brand, slug) ->
      shoe = App.request('shoe:entity', category, brand, slug)
      @showController = new ShoesApp.Show.Controller(shoe)
      App.vent.trigger 'shoe:visited', shoe

    enableShow: ->
      @showController.enable() if @showController
      @listController.disable() if @listController

    enableList: ->
      @listController.enable() if @listController
      @showController.disable() if @showController

    disableShow: ->
      @showController.disable() if @showController

  App.vent.on 'throw:error', ->
    API.disableShow()

  App.vent.on 'visit:home', ->
    API.list()
    API.enableList()
    App.vent.trigger 'visit', '/'

  App.vent.on 'visit:shoe', (slug) ->
    split = _.compact slug.split('/')
    API.show split[0], split[1], split[2]
    App.vent.trigger 'visit', slug
    API.enableShow()

  App.vent.on 'home:visited brand:visited category:visited category:brand:visited', ->
    API.enableList()

  ShoesApp.on 'start', ->
    new ShoesApp.Router
      controller: API