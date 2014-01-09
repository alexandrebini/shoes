@Shoes.module 'NavApp', (NavApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  API =
    show: ->
      new NavApp.Show.Controller()

  NavApp.on 'start', ->
    API.show()