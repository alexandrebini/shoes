class BrandsController < ApplicationController
  respond_to :json
  caches_page :index, :show, :shoes, unless: :is_search_engine?
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def index
    @brands = Brand.with_shoes
    respond_with @brands
  end

  def show
    @brand = Brand.with_shoes.where(slug: params[:slug]).first

    if @brand.blank?
      raise(ActiveRecord::RecordNotFound)
    else
      respond_with @brand
    end
  end

  def shoes
    @brand = Brand.with_shoes.where(slug: params[:slug]).first
    @shoes = @brand.shoes.page(params[:page]).per(params[:per_page])
    respond_with @shoes
  end
end