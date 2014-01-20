class ApplicationController < ActionController::Base
  include ActionController::Caching::Pages

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  caches_page :index, unless: :is_search_engine?

  def index
  end

  def render_404
    render nothing: true, status: '404 Not Found'
  end

  protected
  def is_search_engine?
    params[:search_engine].present?
  end
end
