class CategoriesController < ApplicationController
  respond_to :json

  def show
    @category = Category.where(slug: params[:category]).first
    @shoes = @category.shoes.page(params[:page]).per(params[:per_page])
    respond_with @shoes
  end

  def brand
    @category = Category.where(slug: params[:category]).first
    @brand = @category.brands.where(slug: params[:brand]).first
    @shoes = @brand.shoes.page(params[:page]).per(params[:per_page])
    respond_with @shoes
  end
end