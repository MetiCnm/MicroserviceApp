require 'time'
class NotificationsController < ApplicationController
  include HTTParty
  before_action :administrator_required, only: [:index, :show, :edit, :new]
  before_action :notification, only: [:edit, :update, :destroy, :publish]
  before_action :get_notifications_json, only: [:index, :main]
  before_action :get_notification_json, only: [:show]

  def get_notifications_json
    url = "http://localhost:5141/api/Notification"
    response = HTTParty.get(url).parsed_response
    @notifications = []
    response.each do |notification|
      notifications_params = {
        subject: notification["subject"],
        body: notification["body"],
        published: notification["published"],
        created_at: notification["createdAt"],
        updated_at: notification["modifiedAt"]
      }
      received_notification = Notification.new(notifications_params)
      received_notification.id = notification["notificationId"]
      @notifications << received_notification
    end
  end

  def get_notification_json
    url = "http://localhost:5141/api/Notification/" + params[:id].to_s
    response = HTTParty.get(url).parsed_response
    notifications_params = {
      subject: response["subject"],
      body: response["body"],
      published: response["published"],
      created_at: response["createdAt"],
      updated_at: response["modifiedAt"]
    }
    @notification = Notification.new(notifications_params)
  end

  def index
    @title = "Notifications List"
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
    @title = "Show Notification"
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
    @title = "New Notification"
    @notification = Notification.new
  end

  def create
    url = "http://localhost:5141/api/Notification"
    notification_subject = notification_params[:subject]
    notification_body = notification_params[:body]
    @notification = Notification.new(notification_params)
    if @notification.valid?
      puts "Notification is valid"
      HTTParty.post(url, body: {
        subject: notification_subject,
        body: notification_body,
        published: false,
        created_at: Time.now.iso8601,
        modified_at: Time.now.iso8601,
      })
      flash[:notice] = "Notification added successfully!"
      redirect_to notifications_path
    else
      flash[:error] = "Notification could not be added!"
      render :new
    end
  end

  def edit
    @title = "Edit Notification"
  end

  def update
    if @notification.update(notification_params)
      flash[:notice] = "Notification updated successfully!"
      redirect_to notifications_path
    else
      flash[:error] = "Notification could not be updated!"
      render :edit
    end
  end

  def destroy
    if @notification.destroy
      flash[:notice] = "Notification deleted successfully!"
      redirect_to notifications_path
    else
      flash[:error] = "Notification could not be deleted!"
      render :index
    end
  end

  def publish
    @notification.update_attribute(:published, true)
    flash[:notice] = "Notification published successfully!"
    redirect_to notifications_path
  end

  def main
    @title = "Main Page"
    @main_notifications = @notifications.select {
      |notification| notification["published"] == true }
    @main_notifications.sort { |a, b| a["created_at"] <=> b["created_at"] }
  end

  def notification_params
    params.require(:notification).permit(:subject, :body)
  end

  def notification
    @notification = Notification.find(params[:id])
  end
end
