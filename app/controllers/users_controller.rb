class UsersController < ApplicationController
  include SessionsHelper
  before_action :logged_in_user, only: [ :edit, :update, :show, :index, :destroy ]
  before_action :correct_user, only: [ :edit, :update ]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page]).where(activated: true)
  end

  def new
    @user = User.new
  end
  def show
    @user = User.find_by_id params[:id]
    redirect_to users_path and return unless @user.activated?
  end
  def create
    @user = User.new(user_params)

      if @user.save
        # forwarding_url = session[:forwarding_url]
        # reset_session
        @user.send_activation_email
        flash[:info] = "Please check your email to activate your account."
        # redirect_to forwarding_url || @user
        redirect_to root_path
      else
        render "new", status: :unprocessable_entity
      end
  end

  def edit
    @user = User.find_by_id(params[:id])
  end

  def update
    @user = User.find_by_id params[:id]
    respond_to do | format |
      if @user.update user_params
        format.html { redirect_to user_path(@user), flash: { success:  "Profile Updated" } }
      else
        format.html { render "edit", status: :unprocessable_entity }
      end
    end
  end

  def destroy
    User.find_by_id(params[:id]).destroy
    flash[:destroy] = "User is delete"
    redirect_to users_path, status: :see_other
  end

  private

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please Log in"
      redirect_to log_in_path, status: :see_other
    end
  end

  def correct_user
    @user = User.find_by_id params[:id]
    redirect_to(root_path, status: :see_other) unless current_user?(@user)
  end

  def user_params
    params.require(:user).permit(:name, :email, :password,
    :password_confirmation)
  end

  def admin_user
    redirect_to(root_path, status: :see_other) unless @current_user.admin
  end
end
