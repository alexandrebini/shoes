class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

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
