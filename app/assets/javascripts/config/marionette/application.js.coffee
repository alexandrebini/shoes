do (Backbone) ->

  _.extend Backbone.Marionette.Application::,

    navigate: (route, options = {}) ->
      # add a trailing slash
      if route?
        route = "#{ route }/" if route.slice(-1) isnt '/'
      else
        route = '/'

      @storeRoute()

      # remove double slashes
      route = route.replace(/\/\//g, '/')
      Backbone.history.navigate route, options
      @trackPageView(route) unless options.trackPageView is false

    startHistory: ->
      Backbone.history.start({ pushState: true })
      @trackPageView()

      $('a[data-internal = true]').on 'click', (ev) ->
        ev.preventDefault()

    trackPageView: (route) ->
      unless navigator.userAgent.match(/Googlebot|facebookexternalhit/)
        if route?
          # window.ga 'send', 'pageview', route
        else
          # window.ga 'send', 'pageview'

    scrollTop: ->
      $('body,html').animate({ scrollTop: 0 }, 250)

    setTitle: (title) ->
      $(document).attr 'title', title

    setMetaDescription: (content) ->
      $("meta[name='description']").remove()
      $('head').append $('<meta>', { content: content, name: 'description' })

    setFacebookMeta: (metaTags) ->
      $('meta[property]').remove()

      tags = _.defaults(metaTags, { site_name: 'Shoes', type: 'game', url: location.href })

      _.each tags, (value, key) ->
        if key? && value?
          $('head').append $('<meta>', { content: value, property: "og:#{ key }" })