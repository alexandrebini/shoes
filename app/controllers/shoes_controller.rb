class ShoesController < ApplicationController
  respond_to :json
  def index
    params[:per_page] = 86
    @shoes = Shoe.ready.random.page(params[:page]).per(params[:per_page])
    respond_with @shoes
  end
end