@Shoes.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Header extends Backbone.Model
    defaults:
      logoPath: '/'

    initialize: ->
      @page = App.PageChanger.Changer.getInstance()

    parse: (options) ->
      if options.beforePath
        @set logoPath: @page.previousPath()
      else
        @set logoPath: '/'

  API =
    getHeaderEntity: ->
      @entity = new Entities.Header()

    getUpdateLogoPath: (options) ->
      @entity.parse(options)

  App.reqres.setHandler 'header:entity', ->
    API.getHeaderEntity()

  App.reqres.setHandler 'header:update:logo:path', (options) ->
    API.getUpdateLogoPath(options)