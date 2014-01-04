@Shoes.module 'PageChanger', (PageChanger, App, Backbone, Marionette, $, _) ->
  class PageChanger.Changer
    @getInstance: ->
      @_instance ?= new @(arguments...)

    changePage: (page) ->
      frag = Backbone.history.fragment
      path = if page == 1 then null else "pg-#{ page }"

      frag = frag.replace(/pg-\d+\//, '')
      frag = "#{ frag }#{ path }/" if path
      @navigate frag

    navigate: (route, options = {}) ->
      # add a trailing slash
      if route?
        route = "#{ route }/" if route.slice(-1) isnt '/'
      else
        route = '/'

      # remove double slashes
      route = route.replace(/\/\//g, '/')
      Backbone.history.navigate route, options
      @trackPageView(route) unless options.trackPageView is false

    trackPageView: (route) ->
      unless navigator.userAgent.match(/Googlebot|facebookexternalhit/)
        if route?
          # window.ga 'send', 'pageview', route
        else
          # window.ga 'send', 'pageview'

  App.vent.on 'page:change', (page) ->
    PageChanger.Changer.getInstance().changePage(page)

  PageChanger.on 'start', ->
    PageChanger.Changer.getInstance()