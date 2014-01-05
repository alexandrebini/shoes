@Shoes.module 'ScrollMatcher', (ScrollMatcher, App, Backbone, Marionette, $, _) ->
  class ScrollMatcher.Matcher
    @getInstance: ->
      @_instance ?= new @(arguments...)

    constructor: ->
      App.vent.on 'scroll', @onScroll, @

    onScroll: (value) ->
      console.log 'onScroll'

    watch: (options) ->
      console.log 'watch', options



  API =
    watch: (options) ->
      ScrollMatcher.Matcher.getInstance().watch(options)

  App.vent.on 'scroll:matcher:watch', (options) ->
    API.watch(options)