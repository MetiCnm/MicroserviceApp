class RegistrationsController < ApplicationController
  def new
    @title = "Sign Up"
    @user = User.new
  end

  def create
    @user = User.new(user_signup_params)
    if @user.save
      session[:user_id] = @user.id
      @current_user = current_user
      redirect_to signup_path, notice:"Successfully registered account"
    else
      render :new
    end
  end

  def user_signup_params
    params.require(:user).permit(:name, :surname, :email, :password)
  end
end