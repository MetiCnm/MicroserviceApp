require 'time'
class FinesController < ApplicationController
  include HTTParty
  before_action :administrator_required, only: [:index, :show, :edit, :new]
  before_action :get_fines_json, only: [:index]
  before_action :get_fine_json, only: [:show, :edit, :update, :destroy]

  def get_fines_json
    url = "http://localhost:4000/fines"
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
      vehicle_url_response = HTTParty.get("http://localhost:3001/vehicles/#{fine["vehicle_id"]}").parsed_response
      received_fine = Fine.new(fine_params)
      received_fine._id = fine["_id"]
      received_fine.user_name = fine_user.name
      received_fine.user_surname = fine_user.surname
      received_fine.vehicle_plate_number = vehicle_url_response["plate_number"]
      @fines << received_fine
    end
  end

  def get_fine_json
    url = "http://localhost:4000/fines/" + params[:_id].to_s
    response = HTTParty.get(url).parsed_response
    fine_params = {
      reason: response["reason"],
      place: response["place"],
      issue_time: response["issue_time"],
      amount: response["amount"],
      payment_status: response["payment_status"],
      penalty_amount: response["penalty_amount"],
      user_id: response["user_id"],
      vehicle_id: response["vehicle_id"],
      created_at: response["createdAt"],
      updated_at: response["updatedAt"]
    }
    puts fine_params
    fine_user = User.find_by(id: response["user_id"])
    vehicle_url_response = HTTParty.get("http://localhost:3001/vehicles/#{response["vehicle_id"]}").parsed_response
    @fine = Fine.new(fine_params)
    @fine._id = response["_id"]
    @fine.user_name = fine_user.name
    @fine.user_surname = fine_user.surname
    @fine.vehicle_plate_number = vehicle_url_response["plate_number"]
  end

  def index
    @title = "Fines List"
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
    vehicle_response = HTTParty.get("http://localhost:3001/vehicles").parsed_response
    vehicle_response_count = vehicle_response.count
    @vehicle_list = []
    if vehicle_response_count == 0
      flash[:alert] = "Cannot add a fine without a vehicle!"
      redirect_to vehicles_path
    else
      @title = "New Fine"
      individual_users = User.where(role: 'Individual').ids
      vehicle_response.each do |vehicle|
        if individual_users.include? vehicle["user_id"]
          user = User.find_by(id: vehicle["user_id"])
          vehicle_element = {
            text: vehicle["plate_number"] + " - " + user.name + " " + user.surname,
            id: vehicle["id"].to_s + "-" + user.id.to_s
          }
          @vehicle_list << vehicle_element
        end
      end
      @fine = Fine.new
    end
  end

  def create
    url = "http://localhost:4000/fines"
    fine_reason = fine_params[:reason]
    fine_place = fine_params[:place]
    fine_issue_time = (DateTime.new(fine_params["issue_time(1i)"].to_i,
                                    fine_params["issue_time(2i)"].to_i,
                                    fine_params["issue_time(3i)"].to_i,
                                    fine_params["issue_time(4i)"].to_i,
                                    fine_params["issue_time(5i)"].to_i,
                                    fine_params["issue_time(6i)"].to_i)).iso8601
    fine_amount = fine_params[:amount]
    vehicle_and_user = fine_params[:vehicle_id].split('-')
    fine_vehicle_id = vehicle_and_user[0]
    fine_user_id = vehicle_and_user[1]
    @fine = Fine.new(fine_params)
    if @fine.valid?
      request = HTTParty.post(url,
                              headers: {
                                "Content-Type": "application/json",
                              },
                              body: {
                                reason: fine_reason,
                                place: fine_place,
                                issue_time: fine_issue_time,
                                amount: fine_amount,
                                vehicle_id: fine_vehicle_id,
                                user_id: fine_user_id
                              }.to_json)
      flash[:notice] = "Fine added successfully!"
      redirect_to fines_path
    else
      @vehicle_list = []
      vehicle_response = HTTParty.get("http://localhost:3001/vehicles").parsed_response
      individual_users = User.where(role: 'Individual').ids
      vehicle_response.each do |vehicle|
        if individual_users.include? vehicle["user_id"]
          user = User.find_by(id: vehicle["user_id"])
          vehicle_element = {
            text: vehicle["plate_number"] + " - " + user.name + " " + user.surname,
            id: vehicle["id"].to_s + "-" + user.id.to_s
          }
          @vehicle_list << vehicle_element
        end
      end
      flash[:error] = "Fine could not be added!"
      render :new
    end
  end

  def edit
    vehicle_response = HTTParty.get("http://localhost:3001/vehicles").parsed_response
    vehicle_response_count = vehicle_response.count
    @vehicle_list = []
    if vehicle_response_count == 0
      flash[:alert] = "Cannot add a fine without a vehicle!"
      redirect_to vehicles_path
    else
      individual_users = User.where(role: 'Individual').ids
      vehicle_response.each do |vehicle|
        if individual_users.include? vehicle["user_id"]
          user = User.find_by(id: vehicle["user_id"])
          vehicle_element = {
            text: vehicle["plate_number"] + " - " + user.name + " " + user.surname,
            id: vehicle["id"].to_s + "-" + user.id.to_s
          }
          @vehicle_list << vehicle_element
        end
      end
    end
    @title = "Edit Fine"
    @selected_value = @fine.vehicle_id.to_s + "-" + @fine.user_id.to_s
    @fine.amount = sprintf('%.2f', @fine.amount)
  end

  def update
    url = "http://localhost:4000/fines/" + params[:_id].to_s
    fine_reason = fine_params[:reason]
    fine_place = fine_params[:place]
    fine_issue_time = (DateTime.new(fine_params["issue_time(1i)"].to_i,
                                    fine_params["issue_time(2i)"].to_i,
                                    fine_params["issue_time(3i)"].to_i,
                                    fine_params["issue_time(4i)"].to_i,
                                    fine_params["issue_time(5i)"].to_i,
                                    fine_params["issue_time(6i)"].to_i)).iso8601
    fine_amount = fine_params[:amount]
    vehicle_and_user = fine_params[:vehicle_id].split('-')
    fine_vehicle_id = vehicle_and_user[0]
    fine_user_id = vehicle_and_user[1]
    @fine = Fine.new(fine_params)
    @fine._id = params[:_id]
    puts "Valid: #{@fine.valid?}"
    if @fine.valid?
      request = HTTParty.put(url,
                              headers: {
                                "Content-Type": "application/json",
                              },
                              body: {
                                reason: fine_reason,
                                place: fine_place,
                                issue_time: fine_issue_time,
                                amount: fine_amount,
                                vehicle_id: fine_vehicle_id,
                                user_id: fine_user_id
                              }.to_json)
      flash[:notice] = "Fine updated successfully!"
      redirect_to fines_path
    else
      puts "Error fine _id: " + @fine._id
      @vehicle_list = []
      vehicle_response = HTTParty.get("http://localhost:3001/vehicles").parsed_response
      individual_users = User.where(role: 'Individual').ids
      vehicle_response.each do |vehicle|
        if individual_users.include? vehicle["user_id"]
          user = User.find_by(id: vehicle["user_id"])
          vehicle_element = {
            text: vehicle["plate_number"] + " - " + user.name + " " + user.surname,
            id: vehicle["id"].to_s + "-" + user.id.to_s
          }
          @vehicle_list << vehicle_element
        end
      end
      flash[:error] = "Fine could not be updated!"
      render :edit
    end
  end

  def destroy
    url = "http://localhost:4000/fines/" + @fine._id
    response = HTTParty.delete(url)
    puts response.code
    if response.code == 200
      flash[:notice] = "Fine deleted successfully!"
      redirect_to fines_path
    else
      flash[:error] = "Fine could not be deleted!"
      render :index
    end
  end

  def fine_params
    params.require(:fine).permit(:reason, :place, :issue_time, :amount, :vehicle_id)
  end
end
