class SessionsController < ApplicationController
  def new
    @title = "Log In"
  end

  def create
    @user = User.find_by_email_and_password(params[:email], params[:password])
    if @user
      session[:user_id] = @user.id
      @current_user = current_user
      flash[:notice] = "User logged in successfully!"
      redirect_to user_path(@user)
    else
      flash[:alert] = "Incorrect credentials!"
      render :new
    end
  end
  def destroy
    session[:user_id] = nil
    flash[:notice] = "User logged out successfully!"
    redirect_to login_path
  end
end