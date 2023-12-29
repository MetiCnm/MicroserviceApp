class UsersController < ApplicationController
  def show
    id = params[:id]          # retrieve movie ID from URI route
    @user = User.find(id)     # look up movie by unique ID
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(update_user_params)
      redirect_to user_path(@user), :notice => "User information has been updated."
    else
      #flash[:alert] = "User information could not be updated: " + @user.errors.full_messages.join(",")
      render :edit
    end
  end

  def update_user_params
    params.require(:user).permit(:name, :surname, :email, :password, :national_identification_number, :phone_number, :date_of_birth)
  end
end