class VehiclesController < ApplicationController
  before_action :vehicle, only: [:show, :edit, :update, :destroy]
  before_action :vehicle_user, only: [:create, :update]
  before_action :administrator_required, only: [:index, :show, :edit, :new]
  def index
    @title = "Vehicles List"
    @vehicles = Vehicle.all
  end

  def show
    @title = "Show Vehicle"
  end

  def new
    @title = "New Vehicle"
    @vehicle = Vehicle.new
  end

  def create
    @vehicle = Vehicle.new(vehicle_params)
    @vehicle.user = @user
    if @vehicle.save
      flash[:notice] = "Vehicle added successfully!"
      redirect_to vehicles_path
    else
      flash[:error] = "Vehicle could not be added"
      render :new
    end
  end

  def edit
    @title = "Edit Vehicle"
  end

  def update
    @vehicle.user = @user
    if @vehicle.update(vehicle_params)
      flash[:notice] = "Vehicle updated successfully!"
      redirect_to vehicles_path
    else
      flash[:error] = "Vehicle could not be updated"
      render :edit
    end
  end

  def destroy
    if @vehicle.destroy
      flash[:notice] = "Vehicle deleted successfully!"
      redirect_to vehicles_path
    else
      flash[:error] = "Vehicle could not be deleted"
      render :destroy
    end
  end

  def vehicle_params
    params.require(:vehicle).permit(:plate_number, :vehicle_type, :make, :production_year)
  end

  def vehicle_user_param
    params.require(:vehicle).permit(:user_id)
  end

  def vehicle_user
    @user = User.find(vehicle_user_param["user_id"])
  end

  def vehicle
    @vehicle = Vehicle.find(params[:id])
  end
end

