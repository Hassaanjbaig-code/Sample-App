class UsersController < ApplicationController
  def new
  @user = User.new
  end
  def show
    @user = User.find_by_id params[:id]
  end
  def create
    @user = User.new(user_params)

    respond_to do | format |
      if @user.save
        format.html { redirect_to @user, flash: { success: "Welcome to sample app" } }
      else
        format.html { render "new", status: :unprocessable_entity }
      end
    p @user
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
    :password_confirmation)
  end
end
