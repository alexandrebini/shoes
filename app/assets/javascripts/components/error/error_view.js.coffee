@Shoes.module 'Components.Error', (Error, App, Backbone, Marionette, $, _) ->

  class Error.Layout extends Marionette.Layout
    template: 'error/templates/error_layout'

    regions:
      errorRegion: 'section.errors'

  class Error.NotFound extends Marionette.ItemView
    template: 'error/templates/not_found_view'

    triggers:
      'click .back' : 'error:button:clicked'

  class Error.InternalError extends Marionette.ItemView
    template: 'error/templates/internal_error_view'

    triggers:
      'click .back' : 'error:button:clicked'