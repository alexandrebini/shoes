@Shoes.module 'ScrollMatcher', (ScrollMatcher, App, Backbone, Marionette, $, _) ->
  class ScrollMatcher.Matcher
    gap: 100

    constructor: (view) ->
      @view = view
      App.vent.on 'scroll', @onScroll, @

    onScroll: (scrollTop) ->
      @view.trigger('scroll:matches') if @nearScroll(scrollTop)

    nearScroll: (scrollTop) ->
      firstChild = @view.$el.children().first()
      lastChild = @view.$el.children().last()

      console.log 'firstchild', firstChild.length > 0, 'lastChild', lastChild.length > 0

      top = firstChild.offset().top
      bottom = lastChild.offset().top + lastChild.height()

      # console.log 'scrolltop', scrollTop, 'top', top, 'bottom', bottom
      # console.log "page: #{ @view.model.page }    #{ scrollTop }  #{ top }   #{ top > scrollTop - @gap && top < scrollTop + @gap }"

      if scrollTop > top && scrollTop < bottom
        true
      else
        false

    watch: (options) ->
      console.log 'watch', options