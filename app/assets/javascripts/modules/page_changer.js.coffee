@Shoes.module 'PageChanger', (PageChanger, App, Backbone, Marionette, $, _) ->
  class PageChanger.Changer
    @getInstance: ->
      @_instance ?= new @(arguments...)

    navigate: (route, options = {}) ->
      route = App.UrlHelper.Helper.getInstance().urlFor(route)
      Backbone.history.navigate route, options
      @trackPageView(route)

    changePage: (page) ->
      @navigate App.UrlHelper.Helper.getInstance().pagePath(page)

    trackPageView: (route) ->
      switch
        when navigator.userAgent.match(/Googlebot/)
          ga 'send', 'pageview', 'Googlebot'
        when navigator.userAgent.match(/facebookexternalhit/)
          ga 'send', 'pageview', 'facebook hit'
        when route?
          ga 'send', 'pageview', route
        else
          ga 'send', 'pageview'

  API =
    navigate: (route) ->
      PageChanger.Changer.getInstance().navigate(route)

    changePage: (page) ->
      PageChanger.Changer.getInstance().changePage(page)

  App.vent.on 'page:change', (page) ->
    API.changePage(page)

  App.vent.on 'visit', (route) ->
    API.navigate(route)