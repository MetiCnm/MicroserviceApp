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
      url = "https://vehicle-api-webapp.onrender.com/vehicles"
      response = HTTParty.get(url).parsed_response
      @vehicles = []
      response.each do |vehicle|
        vehicle_params = {
          plate_number: vehicle["plate_number"],
          vehicle_type: vehicle["vehicle_type"],
          make: vehicle["make"],
          production_year: vehicle["production_year"],
          user_id: vehicle["user_id"],
        }
        received_vehicle = Vehicle.new(vehicle_params)
        received_vehicle.id = vehicle["id"]
        @vehicles << received_vehicle
      end
      @vehicles = @vehicles.select { |vehicle| vehicle.user_id == current_user.id}
    else
      redirect_to user_path(@user)
    end
  end

  def fines
    @title = "My Fines"
    if @user.id == current_user.id
      url = "https://finesapi.onrender.com/fines"
      response = HTTParty.get(url).parsed_response
      @fines = []
      response.each do |fine|
        fine_params = {
          reason: fine["reason"],
          place: fine["place"],
          issue_time: fine["issue_time"],
          amount: fine["amount"],
          payment_status: fine["payment_status"],
          penalty_amount: fine["penalty_amount"],
          user_id: fine["user_id"],
          vehicle_id: fine["vehicle_id"],
          created_at: fine["created_at"],
          updated_at: fine["updated_at"]
        }
        fine_user = User.find_by(id: fine["user_id"])
        vehicle_url_response = HTTParty.get("https://vehicle-api-webapp.onrender.com/vehicles/#{fine["vehicle_id"]}").parsed_response
        received_fine = Fine.new(fine_params)
        received_fine._id = fine["_id"]
        received_fine.user_name = fine_user.name
        received_fine.user_surname = fine_user.surname
        received_fine.vehicle_plate_number = vehicle_url_response["plate_number"]
        @fines << received_fine
      end
      @fines = @fines.select { |fine| fine.user_id == current_user.id}
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