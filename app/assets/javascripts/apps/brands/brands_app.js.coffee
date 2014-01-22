@Shoes.module 'BrandsApp', (BrandsApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  class BrandsApp.Router extends Marionette.AppRouter
    addBrandsRoutes: (slugs) ->
      _.each slugs, (slug) =>
        @route "brands/#{ slug }/", => API.show(slug)
        @route "brands/#{ slug }/pg-:page/", (page) => API.show(slug, page)

  API =
    show: (slug, page) ->
      brand = App.request('brand:entity', slug)
      shoes = App.request('brand:shoes:entities', slug, page)

      App.execute 'when:fetched', shoes, =>
        @controller = new BrandsApp.Show.Controller(shoes)
        App.vent.trigger 'brand:visited', brand

    disable: ->
      @controller.disable() if @controller

    enable: ->
      @controller.enable() if @controller

  App.vent.on 'shoe:visited', ->
    API.disable()

  App.vent.on 'visit:brand', (slug) ->
    shortSlug = _.compact(slug.split('/'))
    API.show(_.last(shortSlug))
    API.enable()
    App.vent.trigger 'visit', slug

  BrandsApp.on 'start', (slugs) ->
    router = new BrandsApp.Router
      controller: API
    router.addBrandsRoutes(slugs)
    router