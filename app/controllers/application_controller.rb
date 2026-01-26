class ApplicationController < ActionController::API
  before_action :authorized

  private

  def authorized
    render json: { error: "Not authorized" }, status: :unauthorized unless current_user
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
