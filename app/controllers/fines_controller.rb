class FinesController < ApplicationController
  before_action :fine, only: [:show, :edit, :update, :destroy]
  before_action :fine_vehicle, only: [:create, :update]
  before_action :administrator_required, only: [:index, :show, :edit, :new]

  def index
    @title = "Fines List"
    @fines = Fine.all
    respond_to do |format|
      format.html { }
      format.json {
        render json: @fines
      }
      format.xml {
        render xml: @fines
      }
    end
  end

  def show
    @title = "Show Fine"
    respond_to do |format|
      format.html { }
      format.json {
        render json: @fine
      }
      format.xml {
        render xml: @fine
      }
    end
  end

  def new
    @title = "New Fine"
    @fine = Fine.new
  end

  def create
    @fine = Fine.new(fine_params)
    @fine.vehicle = @vehicle
    @fine.user = @vehicle.user
    if @fine.save
      flash[:notice] = "Fine added successfully!"
      redirect_to fines_path
    else
      flash[:error] = "Fine could not be added!"
      render :new
    end
  end

  def edit
    @title = "Edit Fine"
    @fine.amount = sprintf('%.2f', @fine.amount)
  end

  def update
    @fine.vehicle = @vehicle
    @fine.user = @vehicle.user
    if @fine.update(fine_params)
      flash[:notice] = "Fine updated successfully!"
      redirect_to fines_path
    else
      flash[:error] = "Fine could not be updated!"
      render :edit
    end
  end

  def destroy
    if @fine.destroy
      flash[:notice] = "Fine deleted successfully!"
      redirect_to fines_path
    else
      flash[:error] = "Fine could not be deleted!"
      render :index
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
