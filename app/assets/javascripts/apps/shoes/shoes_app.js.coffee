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

    show: (category, brand, slug) ->
      shoe = App.request('shoe:entity', category, brand, slug)

      App.execute 'when:fetched', shoe, =>
        @showController = new ShoesApp.Show.Controller
          shoe: shoe

        App.vent.trigger 'shoe:visited', shoe


    enableShow: ->
      @showController.enable() if @showController
      @listController.disable() if @listController

    enableList: ->
      @listController.enable() if @listController
      @showController.disable() if @showController

  App.vent.on 'visit:home', ->
    API.list()
    API.enableList()
    App.vent.trigger 'visit', '/'

  App.vent.on 'visit:shoe', (slug) ->
    split = _.compact slug.split('/')
    API.show split[0], split[1], split[2]
    App.vent.trigger 'visit', slug
    API.enableShow()

  ShoesApp.on 'start', ->
    new ShoesApp.Router
      controller: API