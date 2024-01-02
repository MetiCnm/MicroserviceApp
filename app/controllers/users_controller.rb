class UsersController < ApplicationController
  before_action :login_required
  before_action :user, only: [:show, :edit, :update, :vehicles, :fines, :check_user]

  def show
    check_user
  end

  def edit
    check_user
  end

  def update
    if @user.update(update_user_params)
      redirect_to user_path(@user), :notice => "User information has been updated."
    else
      #flash[:alert] = "User information could not be updated: " + @user.errors.full_messages.join(",")
      render :edit
    end
  end

  def vehicles
    if @user.id == current_user.id
      @vehicles = @user.vehicles.all
    else
      redirect_to user_path(@user)
    end
  end

  def fines
    if @user.id == current_user.id
      @fines = @user.fines.all
    else
      redirect_to user_path(@user)
    end
  end

  def update_user_params
    params.require(:user).permit(:name, :surname, :email, :password, :national_identification_number, :phone_number, :date_of_birth)
  end

  def user
    @user = User.find(params[:id])
  end

  def check_user
    unless @user.id == current_user.id
      redirect_to user_path(current_user)
    end
  end
end