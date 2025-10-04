class SessionsController < ApplicationController
  include SessionsHelper
  def new
    @user = User.new
  end

  def create
    @user = User.find_by email: session_params[:email].downcase
    if @user&.authenticate(session_params[:password])
      if @user.activated?
        forwarding_url = session[:forwarding_url]
        reset_session
        params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
        log_in @user
        redirect_to forwarding_url || @user
      else
        message = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_path
      end
    else
        flash[:danger] = "Invalid Email/Password combination"
       render "new", status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path, status: :see_other
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
