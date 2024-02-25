require 'time'
class NotificationsController < ApplicationController
  include HTTParty
  before_action :administrator_required, only: [:index, :show, :edit, :new]
  before_action :get_notifications_json, only: [:index, :main]
  before_action :get_notification_json, only: [:show, :edit, :update, :destroy, :publish]

  def get_notifications_json
    url = "http://localhost:5289/api/Notification"
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
    url = "http://localhost:5289/api/Notification/" + params[:id].to_s
    response = HTTParty.get(url).parsed_response
    notifications_params = {
      id: response["notificationId"],
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
      request = HTTParty.post(url,
        headers: {
          "Content-Type": "application/json",
        },
        body: {
          subject: notification_subject,
          body: notification_body,
          published: false,
          createdat: Time.now.iso8601,
          modifiedat: Time.now.iso8601,
        }.to_json)
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
    url = "http://localhost:5141/api/Notification"
    notification_subject = notification_params[:subject]
    notification_body = notification_params[:body]
    @notification.subject = notification_subject
    @notification.body = notification_body
    if @notification.valid?
      request = HTTParty.put(url,
        headers: {
          "Content-Type": "application/json",
        },
        body: {
          notificationid: @notification.id,
          subject: @notification.subject,
          body: @notification.body,
          published: @notification.published,
          createdat: @notification.created_at,
          modifiedat: @notification.updated_at,
        }.to_json)
      flash[:notice] = "Notification updated successfully!"
      redirect_to notifications_path
    else
      flash[:error] = "Notification could not be updated!"
      render :edit
    end
  end

  def destroy
    url = "http://localhost:5141/api/Notification/" + params[:id].to_s
    response = HTTParty.delete(url)
    if response.code == 200
      flash[:notice] = "Notification deleted successfully!"
      redirect_to notifications_path
    else
      flash[:error] = "Notification could not be deleted!"
      render :index
    end
  end

  def publish
    url = "http://localhost:5141/api/Notification/#{params[:id].to_s}/publish"
    response = HTTParty.post(url)
    if response.code == 200
      flash[:notice] = "Notification published successfully!"
      redirect_to notifications_path
    else
      flash[:error] = "Notification could not be published!"
      render :index
    end
  end

  def main
    @title = "Main Page"
    @main_notifications = @notifications.select { |notification| notification["published"] == true}
    @main_notifications.sort { |a, b| a["created_at"] <=> b["created_at"] }
  end

  def notification_params
    params.require(:notification).permit(:subject, :body)
  end
end
