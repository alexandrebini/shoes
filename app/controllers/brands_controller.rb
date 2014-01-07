class BrandsController < ApplicationController
  respond_to :json

  def show
    @brand = Brand.where(slug: params[:slug]).first
    respond_with @brand
  end

  def shoes
    @brand = Brand.where(slug: params[:slug]).first
    @shoes = @brand.shoes.page(params[:page]).per(params[:per_page])
    respond_with @shoes
  end
end