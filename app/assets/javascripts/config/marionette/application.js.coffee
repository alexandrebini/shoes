do (Backbone) ->

  _.extend Backbone.Marionette.Application::,

    startHistory: ->
      Backbone.history.start({ pushState: true })
      $(document).on 'click', 'a[data-internal]', (ev) ->
        ev.preventDefault()