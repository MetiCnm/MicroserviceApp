class NotificationsController < ApplicationController
  before_action :notification, only: [:show, :edit, :update, :destroy, :publish, :show_json, :show_xml]
  before_action :administrator_required, only: [:index, :show, :edit, :new]

  def index
    @notifications = Notification.all
  end

  def index_json
    @notifications = Notification.all
    render json: @notifications
  end

  def index_xml
    @notifications = Notification.all
    render xml: @notifications
  end

  def show
  end

  def show_json
    render json: @notification
  end

  def show_xml
    render xml: @notification
  end

  def new
    @notification = Notification.new
  end

  def create
    @notification = Notification.new(notification_params)
    if @notification.save
      flash[:notice] = "Notification added successfully!"
      redirect_to notifications_path
    else
      flash[:error] = "Notification could not be added"
      render :new
    end
  end

  def edit
  end

  def update
    if @notification.update(notification_params)
      flash[:notice] = "Notification updated successfully!"
      redirect_to notifications_path
    else
      flash[:error] = "Notification could not be updated"
      render :edit
    end
  end

  def destroy
    if @notification.destroy
      flash[:notice] = "Notification deleted successfully!"
      redirect_to notifications_path
    else
      flash[:error] = "Notification could not be deleted"
      render :destroy
    end
  end

  def publish
    @notification.update_attribute(:published, true)
    flash[:notice] = "Notification published successfully!"
    redirect_to notifications_path
  end

  def main
    @main_notifications = Notification.where(:published => true).order(created_at: :desc)
  end

  def notification_params
    params.require(:notification).permit(:subject, :body)
  end

  def notification
    @notification = Notification.find(params[:id])
  end
end
