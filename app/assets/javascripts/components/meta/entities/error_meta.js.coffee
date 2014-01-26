@Shoes.module 'Components.ErrorMeta.Entities', (Entities, App, Backbone, Marionette, $, _) ->
  class Entities.ErrorMeta extends Backbone.Model
    @getInstance: -> @_instance ?= new @(arguments...)

    parse: (status) ->
      obj = if status == 404
        {
          title: 'Página não encontrada - Busca Sapato',
          metaDescription: 'Esta página não foi encontrada, verifique sua url e tente novamente ou volte para a página inicial.'
        }
      else
        {
          title: 'Bad Bad Server - Busca Sapato',
          metaDescription: 'Opss algum erro aconteceu aqui...'
        }

      @set obj