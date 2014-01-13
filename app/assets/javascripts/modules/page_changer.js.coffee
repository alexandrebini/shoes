@Shoes.module 'PageChanger', (PageChanger, App, Backbone, Marionette, $, _) ->
  class PageChanger.Changer
    @getInstance: ->
      @_instance ?= new @(arguments...)

    navigate: (route, options = {}) ->
      console.log '------'
      route = App.UrlHelper.Helper.getInstance().urlFor(route)
      Backbone.history.navigate route, options
      @trackPageView(route) unless options.trackPageView is false

    changePage: (page) ->
      @navigate App.UrlHelper.Helper.getInstance().pagePath(page)

    trackPageView: (route) ->
      unless navigator.userAgent.match(/Googlebot|facebookexternalhit/)
        if route?
          # window.ga 'send', 'pageview', route
        else
          # window.ga 'send', 'pageview'

  API =
    navigate: (route) ->
      PageChanger.Changer.getInstance().navigate(route)

    changePage: (page) ->
      PageChanger.Changer.getInstance().changePage(page)

  App.vent.on 'page:change', (page) ->
    API.changePage(page)

  App.vent.on 'visit', (route) ->
    API.navigate(route)