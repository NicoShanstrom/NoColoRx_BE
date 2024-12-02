class ApplicationController < ActionController::API
  def current_user
    @_logged_in_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authenticate_user!
    render json: { error: "Not Authorized" }, status: :unauthorized unless current_user
  end
end
