@Shoes.module 'UrlHelper', (UrlHelper, App, Backbone, Marionette, $, _) ->
  class UrlHelper.Helper
    @getInstance: ->
      @_instance ?= new @(arguments...)

    urlFor: (route) ->
      # add a trailing slash
      route = '/' unless route?
      route = "/#{ route }" if route.slice(0) isnt '/'
      route = "#{ route }/" if route.slice(-1) isnt '/'

      # remove double slashes
      route = route.replace(/\/\//g, '/')
      route

    currentPath: ->
      @urlFor Backbone.history.fragment

    currentPage: ->
      path = @currentPath()
      matcher = path.match(/pg-(\d+)\/$/)
      if matcher? && matcher[1]
        parseInt(matcher[1])
      else
        1

    nextPage: ->
      @currentPage() + 1

    previousPage: ->
      currentPage = @currentPage()
      console.log currentPage
      if currentPage <= 1
        1
      else
        currentPage - 1

    pagePath: (page) ->
      frag = Backbone.history.fragment
      path = if page == 1 then null else "pg-#{ page }"
      frag = frag.replace(/pg-\d+\//, '')
      frag = "#{ frag }#{ path }/" if path
      @urlFor frag

    nextPagePath: ->
      @pagePath @nextPage()

    previousPagePath: ->
      @pagePath @previousPage()