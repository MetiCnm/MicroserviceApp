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
      flash[:notice] = "User registered successfully!"
      redirect_to login_path
    else
      flash[:notice] = "User could not be registered!"
      render :new
    end
  end

  def user_signup_params
    params.require(:user).permit(:name, :surname, :email, :password)
  end
end