class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  def current_user
    session[:user_id] && @current_user ||= User.find_by_id(session[:user_id])
  end

end
