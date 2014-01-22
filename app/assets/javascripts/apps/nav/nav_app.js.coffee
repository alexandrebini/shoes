@Shoes.module 'NavApp', (NavApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  API =
    start: ->
      @nav = App.request('nav:entities')
      @categories = @nav.get('categories')
      @brands = @nav.get('brands')

      @controller = new NavApp.Show.Controller
        nav: @nav
        brands: @brands
        categories: @categories

    setCurrentBrand: (brand) ->
      slug = if brand then brand.get('slug') else null
      @nav.setCurrentBrand(slug)

    setCurrentCategory: (category) ->
      slug = if category then category.get('slug') else null
      @nav.setCurrentCategory(slug)

    disable: ->
      @controller.disable()

    enable: ->
      @controller.enable()

  App.vent.on 'shoe:visited', ->
    API.disable()

  App.vent.on 'home:visited', ->
    API.enable()
    API.setCurrentCategory(null)
    API.setCurrentBrand(null)

  App.vent.on 'brand:visited', (brand) ->
    API.enable()
    API.setCurrentBrand(brand)

  App.vent.on 'category:visited', (category) ->
    API.enable()
    API.setCurrentCategory(category)

  App.vent.on 'category:brand:visited', (category, brand) ->
    API.enable()
    API.setCurrentCategory(category)
    API.setCurrentBrand(brand)

  NavApp.on 'start', ->
    API.start()