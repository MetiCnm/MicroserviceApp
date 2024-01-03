class SessionsController < ApplicationController
  def new
    @title = "Log In"
  end

  def create
    @user = User.find_by_email_and_password(params[:email], params[:password])
    if @user
      session[:user_id] = @user.id
      @current_user = current_user
      redirect_to user_path(@user)
    else
      render :new
    end
  end
  def destroy
    session[:user_id] = nil
    redirect_to login_path
  end
end