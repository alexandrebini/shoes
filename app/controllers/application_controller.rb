class ApplicationController < ActionController::Base
  include ActionController::Caching::Pages

  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  caches_page :index, unless: :is_search_engine?
  helper_method :is_search_engine?

  def index
  end

  def render_404
    render nothing: true, status: 404
  end

  def is_search_engine?
    params[:search_engine].present?
  end
end
