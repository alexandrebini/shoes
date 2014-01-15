do (Backbone) ->

  _.extend Backbone.Marionette.Application::,

    startHistory: ->
      Backbone.history.start({ pushState: true })
      $(document).on 'click', 'a[data-internal]', (ev) ->
        console.log 'click', ev
        ev.preventDefault()

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