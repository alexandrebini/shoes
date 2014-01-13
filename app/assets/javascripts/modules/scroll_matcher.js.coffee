@Shoes.module 'ScrollMatcher', (ScrollMatcher, App, Backbone, Marionette, $, _) ->
  class ScrollMatcher.Matcher

    constructor: (view) ->
      @view = view
      App.vent.on 'scroll', @onScroll, @
      @view.on 'after:item:added', @onScroll, @

    onScroll: (scrollTop) ->
      scrollTop = $(window).scrollTop() unless _.isNumber(scrollTop)
      scrollTop = 0 if scrollTop < 0
      topGap = @view.$el.offset().top

      children = @view.children.toArray()
      children = _.sortBy children, (x) -> -x.model.page

      for view in children
        firstChild = view.$el.children().first()

        if firstChild.offset()
          top = firstChild.offset().top - topGap
          if scrollTop >= top
            view.trigger('scroll:matches')
            return