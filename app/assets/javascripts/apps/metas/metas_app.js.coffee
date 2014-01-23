@Shoes.module 'MetasApp', (MetasApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  API =
    metas: (options) ->
      new MetasApp.Meta.Controller(options)

  App.vent.on 'shoe:visited', (shoe) ->
    App.execute 'when:fetched', shoe, =>
      shoe = new Shoes.Components.ShoeMeta.Entities.ShoeMeta().parse(shoe)
      API.metas(shoe)

  App.vent.on 'home:visited', (categories, brands) ->
    App.execute 'when:fetched', [categories, brands], ->
      home = new Shoes.Components.HomeMeta.Entities.HomeMeta().parse(categories, brands)
      API.metas(home)

  App.vent.on 'category:visited', (category) ->
    App.execute 'when:fetched', category, =>
      category = new Shoes.Components.CategoryMeta.Entities.CategoryMeta().parse(category)
      API.metas(category)

  App.vent.on 'brand:visited', (brand) ->
    App.execute 'when:fetched', brand, =>
      brand = new Shoes.Components.BrandMeta.Entities.BrandMeta().parse(brand)
      API.metas(brand)

  App.vent.on 'category:brand:visited', (category, brand, shoes) ->
    App.execute 'when:fetched', [category, brand, shoes], ->
      categoryBrand = new Shoes.Components.CategoryBrandMeta.Entities.CategoryBrandMeta().parse(category, brand, shoes.models[0].models)
      API.metas(categoryBrand)