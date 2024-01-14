class RegistrationsController < ApplicationController
  def new
    if current_user.nil?
      @title = "Sign Up"
      @user = User.new
    else
      redirect_to user_path(current_user)
    end
  end

  def create
    if current_user.nil?
      @user = User.new(user_signup_params)
      if @user.save
        @current_user = current_user
        flash[:notice] = "User registered successfully!"
        redirect_to login_path
      else
        flash[:alert] = "User could not be registered!"
        render :new
      end
    else
      redirect_to user_path(current_user)
    end
  end

  def user_signup_params
    params.require(:user).permit(:name, :surname, :email, :password)
  end
end