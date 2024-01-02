class FinesController < ApplicationController
  before_action :fine, only: [:show, :edit, :update, :destroy]
  before_action :fine_vehicle, only: [:create, :update]
  before_action :administrator_required, only: [:index, :show, :edit, :new]
  def index
    @fines = Fine.all
  end

  def show
  end

  def new
    @fine = Fine.new
  end

  def create
    @fine = Fine.new(fine_params)
    @fine.vehicle = @vehicle
    @fine.user = @vehicle.user
    if @fine.save
      flash[:notice] = "Fine added successfully"
      redirect_to fines_path
    else
      flash[:error] = "Fine could not be added"
      render :new
    end
  end

  def edit
    @fine.amount = sprintf('%.2f', @fine.amount)
  end

  def update
    if @fine.update(fine_params)
      flash[:notice] = "Fine updated successfully"
      redirect_to fines_path
    else
      flash[:error] = "Fine could not be updated"
      render :edit
    end
  end

  def destroy
    if @fine.destroy
      flash[:notice] = "Fine deleted successfully"
      redirect_to fines_path
    else
      flash[:error] = "Fine could not be deleted"
      render :destroy
    end
  end

  def fine_params
    params.require(:fine).permit(:reason, :place, :issue_time, :amount)
  end

  def fine_vehicle_param
    params.require(:fine).permit(:vehicle_id)
  end

  def fine_vehicle
    @vehicle = Vehicle.find(fine_vehicle_param["vehicle_id"])
  end

  def fine
    @fine = Fine.find(params[:id])
  end
end
