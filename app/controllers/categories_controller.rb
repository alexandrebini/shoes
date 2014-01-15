class CategoriesController < ApplicationController
  respond_to :json
  caches_page :index, :show, :shoes, :brand_shoes, unless: :is_search_engine?
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def index
    @categories = Category.with_shoes
    respond_with @categories
  end

  def show
    @category = Category.with_shoes.where(slug: params[:slug]).first
    respond_with @category
  end

  def shoes
    @category = Category.with_shoes.where(slug: params[:slug]).first
    @shoes = @category.shoes.page(params[:page]).per(params[:per_page])
    respond_with @shoes
  end

  def brand_shoes
    @category = Category.with_shoes.where(slug: params[:slug]).first
    @brand = @category.brands.with_shoes.where(slug: params[:brand]).first
    @shoes = @category.shoes.where(brand: @brand).page(params[:page]).per(params[:per_page])
    respond_with @shoes
  end
end