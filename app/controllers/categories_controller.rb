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

    if @category.blank?
      raise ActiveRecord::RecordNotFound
    else
      respond_with @category
    end
  end

  def shoes
    @category = Category.with_shoes.where(slug: params[:slug]).first
    raise ActiveRecord::RecordNotFound if @category.blank?

    @shoes = @category.shoes.page(params[:page]).per(params[:per_page])

    if @shoes.blank?
      raise ActiveRecord::RecordNotFound
    else
      respond_with @shoes
    end
  end

  def brand_shoes
    @category = Category.with_shoes.where(slug: params[:slug]).first
    raise(ActiveRecord::RecordNotFound) if @category.blank?

    @brand = @category.brands.with_shoes.where(slug: params[:brand]).first
    raise(ActiveRecord::RecordNotFound) if @brand.blank?

    @shoes = @category.shoes.where(brand: @brand).page(params[:page]).per(params[:per_page])

    if @brand.blank?
      raise(ActiveRecord::RecordNotFound)
    else
      respond_with @shoes
    end
  end
end