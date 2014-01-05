@Shoes.module 'Components.Pagination.Entities', (Entities, App, Backbone, Marionette, $, _) ->
  class Entities.State extends Backbone.Model
    defaults:
      page: 1
      perPage: null
      totalPages: null
      isLoading: false

    parse: (response) ->
      @set
        page: parseInt(response.page) || 1
        perPage: parseInt(response.perPage)
        totalPages: parseInt(response.totalPages)
        isLoading: false

  class Entities.Page extends Backbone.Collection
    parse: (response) ->
      @page = response.page
      response.records

  class Entities.Pagination extends Backbone.Collection
    initialize: ->
      @state = new Entities.State()

    comparator: (collection) ->
      return collection.page

    parse: (response) ->
      @state.parse(response[0])
      return { records: response[1], page: @state.get('page') }

    nextPage: ->
      _.min [@state.get('page') + 1, @state.get('totalPages')]

    previousPage: ->
      _.max [@state.get('page') - 1, 0]

    getNextPage: ->
      @getPage @nextPage()

    getPreviousPage: ->
      @getPage @previousPage()

    getPage: (index) ->
      if index == @state.get('page') || @state.get('isLoading')
        return false
      else
        @state.set
          page: index
        @fetch()
        index

    fetch: (options) ->
      @state.set
        isLoading: true
      super
        url: @url({ page: @state.get('page') })
        update: true
        remove: false