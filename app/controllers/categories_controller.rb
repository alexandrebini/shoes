class CategoriesController < ApplicationController
  respond_to :json

  def show
    @category = Category.where(slug: params[:slug]).first
    respond_with @category
  end

  def shoes
    @category = Category.where(slug: params[:slug]).first
    @shoes = @category.shoes.page(params[:page]).per(params[:per_page])
    respond_with @shoes
  end

  def brand_shoes
    @category = Category.where(slug: params[:slug]).first
    @brand = @category.brands.where(slug: params[:brand]).first
    @shoes = @category.shoes.where(brand: @brand).page(params[:page]).per(params[:per_page])
    respond_with @shoes
  end
end