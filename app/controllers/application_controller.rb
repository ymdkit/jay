class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  prepend_before_filter :login_state_setup
  before_filter :authenticate

  private
  def login_state_setup
    if session[:user_id]
      User.current = User.find(session[:user_id]) rescue nil
      User.current_access_token = session[:access_token]
    else
      User.current = nil
      User.current_access_token = nil
    end
    return true
  end

  def authenticate
    return true if User.current

    session[:jumpto] = request.parameters
    redirect_to root_path
    return false
  end
end
