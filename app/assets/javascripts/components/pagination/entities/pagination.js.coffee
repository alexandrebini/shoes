@Shoes.module 'Components.Pagination.Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Page extends Backbone.Collection
    parse: (response) ->
      @page = response.page
      response.records

  class Entities.Pagination extends Backbone.Collection
    constructor: (options) ->
      super()
      @state =
        page: options.page || 1

    comparator: (page) ->
      return page.get('page')

    parse: (response) ->
      @parseState response[0]
      return { records: response[1], page: @state.page }

    parseState: (newState) ->
      @state.page = parseInt(newState.page) || 1
      @state.perPage = parseInt(newState.perPage)
      @state.totalPages = parseInt(newState.totalPages)

    nextPage: ->
      _.min [@state.page + 1, @state.totalPages]

    previousPage: ->
      _.max [@state.page - 1, 0]

    getNextPage: ->
      @getPage @nextPage()

    getPreviousPage: ->
      @getPage @previousPage()

    getPage: (index) ->
      @state.page = index
      @fetch()
      return index

    fetch: (options) ->
      super
        url: @url({ page: @state.page })
        update: true
        remove: false