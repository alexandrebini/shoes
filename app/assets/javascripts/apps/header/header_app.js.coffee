@Shoes.module 'HeaderApp', (HeaderApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  API =
    show: ->
      new HeaderApp.Show.Controller()

  HeaderApp.on 'start', ->
    new App.HeadingHelper.Helper()
    API.show()
