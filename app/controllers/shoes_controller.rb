class ShoesController < ApplicationController
  respond_to :json
  def index
    @shoes = Shoe.ready.random.limit(100).all
    respond_with @shoes
  end
end