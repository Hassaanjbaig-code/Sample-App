class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by_id(session[:user_id])
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by_id user_id
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

end
