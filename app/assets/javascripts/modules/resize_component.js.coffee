@Shoes.module 'ResizeComponent', (ResizeComponent, App, Backbone, Marionette, $, _) ->
  class ResizeComponent.Component

    constructor: (layout) ->
      @layout = layout
      # App.vent.on 'resize:main:photo', @resizeMainPhoto, @

    resizeMainPhoto: (a) ->
      mainPhoto = @layout.mainPhotoRegion.$el
      columnPhotoHeight = @layout.$el.first().children().last().height()
      mainPhotoHeight = columnPhotoHeight - @layout.thumbRegion.$el.height()
      mainPhoto.height(mainPhotoHeight)
      @layout.$el.first().children().first().css(height: columnPhotoHeight)