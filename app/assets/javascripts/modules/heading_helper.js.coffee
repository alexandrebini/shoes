@Shoes.module 'HeadingHelper', (HeadingHelper, App, Backbone, Marionette, $, _) ->
  class HeadingHelper.Helper
    constructor: ->
      App.vent.on 'logo:heading:remove', ->
        console.log '-------------'
