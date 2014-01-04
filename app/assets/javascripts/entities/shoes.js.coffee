@Shoes.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  class Entities.ImagesCollection extends Backbone.Collection
    model: Backbone.Model.extend()

  class Entities.GridCollection extends Backbone.Collection
    model: Backbone.Model.extend()

  class Entities.Shoe extends Backbone.Model
    urlRoot: -> Routes.shoes_path()
    idAttribute: 'slug'
    defaults:
      style: 'thumb'
      orientation: ''

    parse: (response) ->
      if response.numerations
        @numerations = new Entities.GridCollection(response.numerations)
        delete response.numerations

      if response.images
        @images = new Entities.ImagesCollection(response.images)
        delete response.images

      response

  class Entities.ShoesGroup extends Backbone.Collection
    model: Entities.Shoe

  class Entities.ShoesCollection extends Backbone.PageableCollection
    model: Entities.ShoesGroup
    url: -> Routes.shoes_path()

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
        { style: 'long' }, {}, { style: 'long', orientation: 'right' }, {},
      ]
      long_top_right: [
        { style: 'long', orientation: 'right' }, {}, {}, {}, {},
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

    state:
      currentType: 'long_bottom_left'
      firstPage: 1
      currentPage: 1
      pageSize: ->
        _.reduce(ShoesCollection.prototype.types, (memo, type) ->
          memo + _.keys(type).length
        , 0) * 2

    parseRecords: (resp, options) ->
      shoes = super(resp, options)
      shoesGroups = []

      i = 0
      while i < shoes.length
        type = @types[@state.currentType]
        slice = shoes.slice(i, i + type.length)
        shoesGroups.push(slice)
        @applyType(slice, type)
        i = i + type.length
        @nextType()

      return shoesGroups

    applyType: (shoes, type) ->
      for attrs, index in type
        for key, value of attrs
          shoes[index][key] = value

    nextType: ->
      keys = _.keys(@types)
      currentIndex = keys.indexOf(@state.currentType)
      if currentIndex == keys.length - 1
        @state.currentType = keys[0]
      else
        @state.currentType = keys[currentIndex + 1]

  API =
    getShoes: ->
      shoes = new Entities.ShoesCollection
      shoes.fetch()
      shoes

    getShoe: (slug) ->
      shoe = new Entities.Shoe
      shoe.fetch
        url: Routes.shoe_path(slug)
      shoe

  App.reqres.setHandler 'shoe:entity', (slug) ->
    API.getShoe slug

  App.reqres.setHandler 'shoes:entities', ->
    API.getShoes()
