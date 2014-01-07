@Shoes.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  class Entities.Photo extends Backbone.Model
    parse: (response) -> @set response.toJSON()

  class Entities.PhotosCollection extends Backbone.Collection
    initialize: ->
      @mainPhoto = new Entities.Photo()

    setMainCurrent: (model) ->
      @mainPhoto.parse model || _.first(_.map(@models, (model) ->
        model if model.get('main')
      ))

  class Entities.Number extends Backbone.Model
    defaults:
      className: ''

    parse: (klass) ->
      @set className: klass

  class Entities.GridCollection extends Backbone.Collection
    model: Entities.Number

    attrs:
      maximumPercent: 100
      minimumPercent: 10
      percent: 100
      gap: 15
      direction: 'down'

    parse: ->
      @setClassName()
      @

    setClassName: ->
      for model in @models
        model.parse("opacity-#{ @attrs['percent'] }") unless model.get('className')
        @setPercentNew()

    setPercentNew: ->
        if @getDirection() == 'down'
          @attrs['percent'] = @attrs['percent'] - @attrs['gap']
        else
          @attrs['percent'] = @attrs['percent'] + @attrs['gap']

    getDirection: ->
      if @attrs['percent'] - @attrs['gap'] < @attrs['minimumPercent']
        @attrs['direction'] = 'up'

      if @attrs['percent'] + @attrs['gap'] > @attrs['maximumPercent']
        @attrs['direction'] = 'down'

      @attrs['direction']

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

      if response.photos
        @photos = new Entities.PhotosCollection(response.photos)
        delete response.photos

      response

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
          shoes[index][key] = value

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

  API =
    getShoes: (page) ->
      shoes = new Entities.ShoesPagination()
      shoes.state.setPage(page)
      shoes.fetch()
      shoes

    getShoe: (slug) ->
      shoe = new Entities.Shoe
      shoe.fetch
        url: Routes.shoe_path(slug)
      shoe

  App.reqres.setHandler 'shoe:entity', (slug) ->
    API.getShoe(slug)

  App.reqres.setHandler 'shoes:entities', (page) ->
    API.getShoes(page)