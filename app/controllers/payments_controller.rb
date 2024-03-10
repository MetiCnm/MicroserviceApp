class PaymentsController < ApplicationController
  before_action :fine, only: [:new, :penalty_check, :pay]
  before_action :individual_required, only: [:new]
  skip_before_action :verify_authenticity_token, only: [:pay]
  def new
    @title = "Pay Fine"
    if @fine.payment_status
      redirect_to fines_path
    else
      @payment = Payment.new
    end
  end

  def payment_params
    params.require(:payment).permit(:credit_card_number, :expiration_date, :card_verification_number)
  end

  def fine
    url = "https://finesapi.onrender.com/fines/" + params[:_id].to_s
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
    vehicle_url_response = HTTParty.get("https://vehicle-api-webapp.onrender.com/vehicles/#{response["vehicle_id"]}").parsed_response
    @fine = Fine.new(fine_params)
    @fine._id = response["_id"]
    @fine.user_name = fine_user.name
    @fine.user_surname = fine_user.surname
    @fine.vehicle_plate_number = vehicle_url_response["plate_number"]
  end

  def penalty_check
    url = "https://finesapi.onrender.com/fines/" + @fine._id.to_s
    @days_count = (Time.now.to_date - @fine.issue_time.to_date).to_i
    if @days_count <= 5
      fine_amount = @fine.amount / 2
      request = HTTParty.put(url,
                             headers: {
                               "Content-Type": "application/json",
                             },
                             body: {
                               amount: fine_amount,
                               payment_status: true,
                               penalty_amount: 0.00
                             }.to_json)
    else
      accumulated_payment = calculate_interest(2, @fine.amount, @days_count)
      penalty_fee = accumulated_payment - @fine.amount
      #@fine.update_attribute(:penalty_amount, @penalty_fee)
      #@fine.update_attribute(:payment_status, true)
      request = HTTParty.put(url,
                             headers: {
                               "Content-Type": "application/json",
                             },
                             body: {
                               amount: @fine.amount,
                               payment_status: true,
                               penalty_amount: penalty_fee
                             }.to_json)
      @payment.update_attribute(:amount, accumulated_payment)
    end
  end

  def calculate_interest(interest, amount, days)
    amount * (1.0 + (interest / 100.00)) ** days
  end

  def pay
    if logged_in?
      @current_user = current_user
      @current_user_role = @current_user.role
    else
      @current_user = nil
      @current_user_role = nil
    end
    respond_to do |format|
      if @fine.payment_status
        format.html {
          if @current_user_role == "Individual"
            flash[:error] = "Fine has been paid already!"
            redirect_to fines_path
          else
            redirect_to root_path
          end
        }
        format.json {
          render json: { error: "Fine has been paid already!" }
        }
      else
        @payment = Payment.new(payment_params)
        @payment.fine_id = @fine._id
        if @payment.valid?
          penalty_check
          @payment.save
          format.html {
            if @current_user_role == "Individual"
              flash[:notice] = "Payment added successfully!"
              redirect_to fines_path
            else
              redirect_to root_path
            end
          }
          format.json {
            render json: { success: "Payment added successfully!" }
          }
        else
          format.html {
            if @current_user_role == "Individual"
              flash[:error] = "Payment could not be added!"
              render :new
            else
              redirect_to root_path
            end
          }
          format.json {
            render json: { error: "Validation failed for payment", messages: @payment.errors.full_messages }
          }
        end
      end
    end
  end
end
