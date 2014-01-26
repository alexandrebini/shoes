@Shoes.module 'MetasApp', (MetasApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  API =
    metas: (options) ->
      App.Components.Meta.Controller.getInstance().set(options)

    default: ->
      App.Components.Meta.Controller.getInstance().default()

  App.vent.on 'shoe:visited', (shoe) ->
    API.default()

    App.execute 'when:fetched', shoe, =>
      shoe = App.Components.ShoeMeta.Entities.ShoeMeta.getInstance().parse(shoe)
      API.metas(shoe)

  App.vent.on 'home:visited', ->
    API.default()

    categories = App.request('category:entities')
    brands = App.request('brand:entities')

    App.execute 'when:fetched', [categories, brands], ->
      home = App.Components.HomeMeta.Entities.HomeMeta.getInstance().parse(categories, brands)
      API.metas(home)

  App.vent.on 'category:visited', (category) ->
    API.default()

    App.execute 'when:fetched', category, =>
      category = App.Components.CategoryMeta.Entities.CategoryMeta.getInstance().parse(category)
      API.metas(category)

  App.vent.on 'brand:visited', (brand) ->
    API.default()

    App.execute 'when:fetched', brand, =>
      brand = App.Components.BrandMeta.Entities.BrandMeta.getInstance().parse(brand)
      API.metas(brand)

  App.vent.on 'category:brand:visited', (category, brand, shoes) ->
    API.default()

    App.execute 'when:fetched', [category, brand, shoes], ->
      categoryBrand = App.Components.CategoryBrandMeta.Entities.CategoryBrandMeta.getInstance().parse(category, brand, shoes.models[0].models)
      API.metas(categoryBrand)