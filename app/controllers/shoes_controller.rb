class ShoesController < ApplicationController
  def index
    @shoes = Shoe.limit(300)
  end
end