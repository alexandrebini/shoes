@Shoes.module 'ResizeComponent', (ResizeComponent, App, Backbone, Marionette, $, _) ->
  class ResizeComponent.Component

    constructor: (layout) ->
      @layout = layout
      App.vent.on 'resize:main:photo', @resizeMainPhoto, @

    resizeMainPhoto: ->
      mainPhoto = @layout.mainPhotoRegion.$el
      mainPhoto.height(mainPhoto.height())
      columnPhotoHeight = @layout.$el.first().children().first().height()
      @layout.$el.first().children().last().css(maxHeight: columnPhotoHeight)