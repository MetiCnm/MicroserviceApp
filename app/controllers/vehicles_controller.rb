require 'time'
class VehiclesController < ApplicationController
  include HTTParty
  before_action :vehicle, only: [:show, :edit, :update, :destroy]
  before_action :vehicle_user, only: [:create, :update]
  before_action :administrator_required, only: [:index, :show, :edit, :new]

  def get_vehicles_json
    url = "http://localhost:3001/vehicles"
    response = HTTParty.get(url).parsed_response
    @vehicles = []
    response.each do |vehicle|
      vehicle_params = {
        plate_number: vehicle["plate_number"],
        vehicle_type: vehicle["vehicle_type"],
        make: vehicle["make"],
        user_id: vehicle["user_id"],
      }
      received_vehicle = Vehicle.new(vehicle_params)
      received_vehicle.id = vehicle["id"]
      @vehicles << received_vehicle
    end
  end

  def get_vehicle_json
    url = "http://localhost:3001/vehicles" + params[:id].to_s
    response = HTTParty.get(url).parsed_response
    notifications_params = {
      id: response["id"],
      plate_number: response["plate_number"],
      vehicle_type: response["vehicle_type"],
      make: response["make"],
      user_id: response["user_id"]
    }
    @vehicle = Notification.new(notifications_params)
  end

  def index
    @title = "Vehicles List"
    respond_to do |format|
      format.html { }
      format.json {
        render json: @notifications
      }
      format.xml {
        render xml: @notifications
      }
    end
  end

  def show
    @title = "Show Vehicle"
    respond_to do |format|
      format.html { }
      format.json {
        render json: @notification
      }
      format.xml {
        render xml: @notification
      }
    end
  end

  def new
    @title = "New Vehicle"
    @vehicle = Vehicle.new
  end

  def create
    url = "http://localhost:3001/vehicles"
    vehicle_plate_number = vehicle_params[:plate_number]
    vehicle_type = vehicle_params[:vehicle_type]
    vehicle_make = vehicle_params[:make]
    vehicle_production_year = vehicle_params[:production_year]
    vehicle_user_id = vehicle_params[:user_id]
    @vehicle = Vehicle.new(vehicle_params)
    if @vehicle.valid?
      request = HTTParty.post(url,
        headers: {
          "Content-Type": "application/json",
        },
        body: {
          plate_number: vehicle_plate_number,
          type: vehicle_type,
          make: vehicle_make,
          production_year: vehicle_production_year,
          user_id: vehicle_user_id
        }
      )
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
      render :index
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

