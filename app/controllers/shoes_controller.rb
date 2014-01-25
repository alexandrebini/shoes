class ShoesController < ApplicationController
  respond_to :json
  caches_page :index, :show, unless: :is_search_engine?
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def index
    @shoes = Shoe.ready.page(params[:page]).per(params[:per_page])
    respond_with @shoes
  end

  def show
    @shoe = Shoe.ready.where(slug: params[:slug]).first
    respond_with @shoe
  end
end