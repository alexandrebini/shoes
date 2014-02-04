@Shoes.module 'PageChanger', (PageChanger, App, Backbone, Marionette, $, _) ->
  class PageChanger.Changer
    @getInstance: ->
      @_instance ?= new @(arguments...)

    constructor: ->
      @history = []

    navigate: (route, options) ->
      route = App.UrlHelper.Helper.getInstance().urlFor(route)
      Backbone.history.navigate route, options
      @trackPageView(route)
      @storeRoute()

    changePage: (page) ->
      @navigate App.UrlHelper.Helper.getInstance().pagePath(page)

    storeRoute: ->
      @history.push Backbone.history.fragment
      window.foo = @history

    previousPath: ->
      step = 2
      @history[@history.length - step]

    trackPageView: (route) ->
      return if App.isSearchEngine
      if route?
        ga 'send', 'pageview', route
      else
        ga 'send', 'pageview'

  API =
    navigate: (options) ->
      PageChanger.Changer.getInstance().navigate(options.route, options.visit)

    changePage: (page) ->
      PageChanger.Changer.getInstance().changePage(page)

  App.vent.on 'page:change', (page) ->
    API.changePage(page)

  App.vent.on 'visit', (options) ->
    API.navigate(options)