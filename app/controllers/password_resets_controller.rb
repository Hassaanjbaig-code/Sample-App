class PasswordResetsController < ApplicationController
  before_action :get_user, only: [ :edit, :update ]
  before_action :valid_user, only: [ :edit, :update ]
  include SessionsHelper
  def new
  end

  def create
    @user = User.find_by(email: reset_params[:email])
    if @user
      @user.create_password_reset
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset intruction"
      redirect_to root_url
    else
      flash[:danger] = "Email is not found"
      render "new", status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render "edit", status: :unprocessable_entity
    elsif @user.update(user_params)
      reset_session
      log_in @user
      @user.forget
      flash[:success] = "Password has been reset"
      redirect_to @user
    else 
      render "edit", status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
      unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
        redirect_to root_path
      end
  end

  def check_expiration
    @user.password_reset_expired?
    flash[:danger] = "Password reset has expired"
    redirect_to new_password_reset_url
  end

  def reset_params
    params.require(:password_reset).permit(:email)
  end
end
