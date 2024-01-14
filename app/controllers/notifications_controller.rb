class NotificationsController < ApplicationController
  before_action :administrator_required, only: [:index, :show, :edit, :new]
  before_action :notification, only: [:show, :edit, :update, :destroy, :publish]

  def index
    @title = "Notifications List"
    @notifications = Notification.all
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
    @notification = Notification.new(notification_params)
    if @notification.save
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
    @main_notifications = Notification.where(:published => true).order(created_at: :desc)
  end

  def notification_params
    params.require(:notification).permit(:subject, :body)
  end

  def notification
    @notification = Notification.find(params[:id])
  end
end
