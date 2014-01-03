class ShoesController < ApplicationController
  respond_to :json
  def index
    @shoes = Shoe.ready.random.page(params[:page]).per(params[:per_page])
    respond_with @shoes
  end

  def show
    @shoe = Shoe.where(slug: params[:slug]).first
    respond_with @shoe
  end
end