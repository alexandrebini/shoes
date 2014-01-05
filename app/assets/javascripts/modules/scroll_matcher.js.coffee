@Shoes.module 'ScrollMatcher', (ScrollMatcher, App, Backbone, Marionette, $, _) ->
  class ScrollMatcher.Matcher
    gap: 100

    constructor: (view) ->
      @view = view
      App.vent.on 'scroll', @onScroll, @

    onScroll: (scrollTop) ->
      @view.trigger('scroll:matches') if @nearScroll(scrollTop)

    nearScroll: (scrollTop) ->
      child = @view.$el.children().first()
      scrollTop = Math.round(scrollTop)
      top = Math.round(child.offset().top)

      console.log "page: #{ @view.model.page }    #{ scrollTop }  #{ top }   #{ top > scrollTop - @gap && top < scrollTop + @gap }"

      if top > scrollTop - @gap && top < scrollTop + @gap
        true
      else
        false

    watch: (options) ->
      console.log 'watch', options