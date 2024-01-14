class UsersController < ApplicationController
  before_action :login_required, only: [:show, :edit, :update]
  before_action :individual_required, only: [:vehicles, :fines]
  before_action :user, only: [:show, :edit, :update, :vehicles, :fines, :check_user]

  def show
    @title = "Show User"
    check_user
  end

  def edit
    @title = "Edit User"
    check_user
  end

  def update
    if @user.update(update_user_params)
      flash[:notice] = "User profile has been updated successfully!"
      redirect_to user_path(@user)
    else
      flash[:alert] = "User profile could not be updated!"
      render :edit
    end
  end

  def vehicles
    @title = "My Vehicles"
    if @user.id == current_user.id
      @vehicles = @user.vehicles.all
    else
      redirect_to user_path(@user)
    end
  end

  def fines
    @title = "My Fines"
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