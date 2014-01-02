class ShoesController < ApplicationController
  def index
    @shoes = Shoe.ready.random
  end
end