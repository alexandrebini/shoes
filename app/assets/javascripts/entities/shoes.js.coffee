@Shoes.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Shoe extends Backbone.Model
    urlRoot: -> Routes.shoes_path()
    idAttribute: 'slug'
    defaults:
      style: 'thumb'
      orientation: ''

  class Entities.ShoesGroup extends Backbone.Collection
    model: Entities.Shoe

  class Entities.ShoesCollection extends App.Components.Pagination.Entities.Page
    model: Entities.ShoesGroup
    url: => Routes.shoes_path()

    types:
      long_bottom_left: [
        {}, {}, { style: 'long' }, {}, {}
      ]
      long_bottom_left_top_right: [
        { style: 'long', orientation: 'right' }, {}, { style: 'long' }, {}
      ]
      long_bottom_right: [
        {}, {}, {}, { style: 'long', orientation: 'right' }, {}
      ]
      long_top_left: [
        { style: 'long' }, {}, {}, {}, {}
      ]
      long_top_left_bottom_right: [
        { style: 'long' }, {}, { style: 'long', orientation: 'right' }, {}
      ]
      long_top_right: [
        { style: 'long', orientation: 'right' }, {}, {}, {}, {}
      ]
      wide_bottom: [
        {}, {}, {}, {}, { style: 'wide' }
      ]
      wide_middle: [
        {}, {}, { style: 'wide' }, {}, {}
      ]
      wide_top: [
        { style: 'wide' }, {}, {}, {}, {}
      ]

    currentType: 'long_bottom_left'

    parse: (response) ->
      response = super(response)
      shoesGroups = []

      i = 0
      while i < response.length
        type = @types[@currentType]
        slice = response.slice(i, i + type.length)
        if slice.length > 0
          shoesGroups.push(slice)
          @applyType(slice, type)
        i = i + type.length
        @nextType()

      return shoesGroups

    applyType: (shoes, type) ->
      for attrs, index in type
        for key, value of attrs
          shoes[index][key] = value if shoes[index]

    nextType: ->
      keys = _.keys(@types)
      currentIndex = keys.indexOf(@currentType)
      if currentIndex == keys.length - 1
        @currentType = keys[0]
      else
        @currentType = keys[currentIndex + 1]

  class Entities.ShoesPagination extends App.Components.Pagination.Entities.Pagination
    model: Entities.ShoesCollection
    url: Routes.shoes_path

    # state:
    #   pageSize: ->
    #     _.reduce(Entities.ShoesCollection.prototype.types, (memo, type) ->
    #       memo + _.keys(type).length
    #     , 0) * 2

  API =
    getShoes: (page) ->
      shoes = new Entities.ShoesPagination()
      shoes.state.set
        page: page
      shoes.fetch()
      shoes

  App.reqres.setHandler 'shoes:entities', (page) ->
    API.getShoes(page)